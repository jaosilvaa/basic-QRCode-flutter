import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/ui/result/pages/result_screen.dart';
import 'package:qrqrcode/scr/ui/scanner/controllers/qr_scanner_controller.dart';
import 'package:qrqrcode/scr/ui/scanner/widgets/qr_scanner_camera_frame.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with WidgetsBindingObserver {
  late final QrScannerController _scanner;
  StreamSubscription<BarcodeCapture>? _subscription;

  bool isZoomSliderVisible = false;
  double sliderZoomValue = QrScannerController.minZoom;
  Timer? _zoomHideTimer;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scanner = QrScannerController();
    sliderZoomValue = _scanner.currentZoom;
    _subscription =
        _scanner.mobileController.barcodes.listen(_handleBarcodeCapture);
    _startCamera();
  }

  Future<void> _startCamera() async {
    await _scanner.startCamera();
    if (!mounted) return;
    if (_scanner.isFlashOn && !_scanner.isFrontCamera) {
      await Future.delayed(const Duration(milliseconds: 400));
      try {
        await _scanner.toggleTorch();
        if (mounted) setState(() {});
      } catch (_) {}
    }
  }

  Future<void> _stopCamera() async => _scanner.stopCamera();

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      await _analyzeQrImage(pickedImage.path);
    }
  }

  Future<void> _analyzeQrImage(String imagePath) async {
    try {
      final result = await _scanner.mobileController.analyzeImage(imagePath);
      if (result != null && result.barcodes.isNotEmpty) {
        _navigateToResult(result.barcodes.first.rawValue ?? '---');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nenhum QR Code encontrado na imagem.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error analyzing image: $e');
    }
  }

  void _handleBarcodeCapture(BarcodeCapture capture) {
    if (_scanner.isScanCompleted || capture.barcodes.isEmpty) return;
    final barcode = capture.barcodes.first;
    _navigateToResult(barcode.rawValue ?? '---');
  }

  Future<void> _navigateToResult(String code) async {
    setState(() => _scanner.isScanCompleted = true);
    await _stopCamera();
    if (!mounted) return;

    await context.push(
      '/scanner/result',
      extra: ScanResult.fromRawValue(code),
    );

    if (mounted) {
      setState(() => _scanner.isScanCompleted = false);
      await _scanner.resetZoom();
      await _startCamera();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_scanner.isScanCompleted) {
      _startCamera();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _stopCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _scanner.dispose();
    _zoomHideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide >= 600;

    final appBarColor = isDark ? AppColors.white : AppColors.black;
    final appBarIconColor = isDark ? AppColors.black : AppColors.white;
    final containerCurvoColor = isDark ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        iconTheme: IconThemeData(color: appBarIconColor),
        title: Center(
          child: Image.asset(
            isDark ? 'assets/logo.png' : 'assets/logo2.png',
            height: 34,
          ),
        ),
        actions: [
          _buildIconButton(
            iconPath: _scanner.isFlashOn ? 'assets/7.svg' : 'assets/8.svg',
            color: appBarIconColor,
            onPressed: () async {
              await _scanner.toggleTorch();
              if (mounted) setState(() {});
            },
          ),
          _buildIconButton(
            iconPath: 'assets/6.svg',
            color: appBarIconColor,
            onPressed: () async {
              try {
                await _scanner.switchCamera();
                if (mounted) setState(() {});
              } catch (_) {}
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;
            final double cardHeight = isTablet
                ? availableHeight * 0.18
                : availableHeight * 0.25;

            final double scannerSize =
                isTablet ? constraints.maxWidth * 0.45 : constraints.maxWidth * 0.65;

            final double scannerBorderRadius = isTablet ? 40 : 25;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      _buildCurvedBackground(
                        height: cardHeight,
                        color: containerCurvoColor,
                        isTablet: isTablet,
                      ),
                      Column(
                        children: [
                          SizedBox(height: isTablet ? 50 : 35),
                          _buildInstructionCard(theme, isTablet, isDark),
                          SizedBox(height: isTablet ? 40 : 20),

                          // Câmera Frame
                          QrScannerCameraFrame(
                            scannerSize: scannerSize,
                            borderRadius: scannerBorderRadius,
                            controller: _scanner.mobileController,
                            onScaleStart: (details) {
                              _zoomHideTimer?.cancel();
                              setState(() {
                                isZoomSliderVisible = true;
                                sliderZoomValue = _scanner.currentZoom;
                              });
                              _scanner.onScaleStart();
                            },
                            onScaleUpdate: (details) async {
                              await _scanner.onScaleUpdate(details.scale);
                              setState(() {
                                sliderZoomValue = _scanner.currentZoom;
                              });
                            },
                            onScaleEnd: (details) {
                              _zoomHideTimer?.cancel();
                              _zoomHideTimer =
                                  Timer(const Duration(seconds: 2), () {
                                if (!mounted) return;
                                setState(() => isZoomSliderVisible = false);
                              });
                            },
                          ),

                          const SizedBox(height: 16),

                          // Slider logo abaixo da câmera
                          if (isZoomSliderVisible)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: SfSlider(
                                min: QrScannerController.minZoom,
                                max: 1.0,
                                thumbIcon: Icon(Icons.zoom_in, color: theme.colorScheme.surface,size: 18,),
                                value: sliderZoomValue,
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.neutralMidLightGrey,
                                onChanged: (dynamic value) async {
                                  final zoom = value as double;

                                  _zoomHideTimer?.cancel();

                                  setState(() {
                                    sliderZoomValue = zoom;
                                    isZoomSliderVisible = true;
                                  });

                                  await _scanner.setZoom(zoom);
                                },
                                onChangeEnd: (dynamic value) {
                                  _zoomHideTimer?.cancel();
                                  _zoomHideTimer =
                                      Timer(const Duration(seconds: 2), () {
                                    if (!mounted) return;
                                    setState(
                                      () => isZoomSliderVisible = false,
                                    );
                                  });
                                },
                              ),
                            ),

                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required String iconPath,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        iconPath,
        width: 23,
        height: 23,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildCurvedBackground({
    required double height,
    required Color color,
    required bool isTablet,
  }) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(isTablet ? 200 : 100),
            bottomRight: Radius.circular(isTablet ? 200 : 100),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard(
    ThemeData theme,
    bool isTablet,
    bool isDark,
  ) {
    final cardBorderColor =
        isDark ? AppColors.neutralGrey900 : AppColors.neutralMidLightGrey;
    final cardTextColor = isDark ? AppColors.white : AppColors.black;
    final cardSubtitleColor = AppColors.neutralDarkGrey;
    final cardPadding = isTablet ? 32.0 : 20.0;
    final cardBorderRadius = isTablet ? 50.0 : 30.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: cardBorderColor, width: 1.6),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Place the QR code\nin the area',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: cardTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Scanning will start\nautomatically',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cardSubtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Image.asset(
                    'assets/bc.png',
                    width: isTablet ? 120 : 100,
                    height: isTablet ? 110 : 90,
                    color: !isDark ? Colors.black : null,
                    colorBlendMode:
                        !isDark ? BlendMode.srcIn : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildGalleryButton(
              theme,
              cardBorderColor,
              cardTextColor,
              cardSubtitleColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryButton(
    ThemeData theme,
    Color borderColor,
    Color textColor,
    Color iconColor,
  ) {
    return DottedBorder(
      color: borderColor,
      borderType: BorderType.RRect,
      radius: const Radius.circular(14),
      dashPattern: const [6, 3],
      strokeWidth: 1.5,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: _pickImageFromGallery,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/gallery.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
                const SizedBox(width: 10),
                Text(
                  "From gallery",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
