import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:qrqrcode/scr/ui/result/pages/result_screen.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with WidgetsBindingObserver {
  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;

  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  StreamSubscription<BarcodeCapture>? _subscription;

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      await analyzeQR(pickedImage.path);
    }
  }

  Future<void> analyzeQR(String imagePath) async {
    try {
      final result = await controller.analyzeImage(imagePath);
      if (result != null && result.barcodes.isNotEmpty) {
        String code = result.barcodes.first.rawValue ?? '---';
        setState(() => isScanCompleted = true);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              result: ScanResult.fromRawValue(code),
            ),
          ),
        );
        if (mounted) {
           setState(() => isScanCompleted = false);
        }
      } else {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhum QR Code encontrado na imagem.')),
          );
        }
      }
    } catch (e) {
      debugPrint("Error analyzing image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcodeCapture);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Lógica do flash mantida
      if (isFlashOn && controller.value.torchState == TorchState.off) {
        controller.toggleTorch();
      } else if (!isFlashOn && controller.value.torchState == TorchState.on) {
        controller.toggleTorch();
      }
      // Reinicia o scanner se não estivermos no meio de uma leitura
      if(!isScanCompleted) {
        controller.start();
      }
    } else {
      // Pausa o scanner para economizar bateria quando o app não está em foco
      controller.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _handleBarcodeCapture(BarcodeCapture capture) async {
    if (isScanCompleted || capture.barcodes.isEmpty) return;
    final barcode = capture.barcodes.first;
    final String code = barcode.rawValue ?? '---';
    setState(() => isScanCompleted = true);
    await controller.stop();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultScreen(result: ScanResult.fromRawValue(code)),
      ),
    );
    if(mounted) {
      setState(() => isScanCompleted = false);
      controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pegando as definições do tema atual (seja light ou dark)
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final bool tablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      // Cor de fundo vinda do tema
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: Drawer(
       
      ),
      appBar: AppBar(
   
        backgroundColor: theme.colorScheme.onSecondary,
        elevation: 0,
        title: Center(child: Image.asset('assets/logo.png', height: 34)),
        iconTheme: IconThemeData(color: theme.colorScheme.secondary),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => isFlashOn = !isFlashOn);
              controller.toggleTorch();
            },
            icon: SvgPicture.asset(
              isFlashOn ? 'assets/7.svg' : 'assets/8.svg',
              width: 23,
              height: 23,
            
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() => isFrontCamera = !isFrontCamera);
              controller.switchCamera();
            },
            icon: SvgPicture.asset(
              'assets/6.svg',
              width: 23,
              height: 23,
              //colorFilter: ColorFilter.mode(isDark ? Colors.white : Colors.black87, BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableHeight = constraints.maxHeight;
            final double cardHeight = tablet ? availableHeight * 0.18 : availableHeight * 0.25;
            final double scannerSize = tablet ? constraints.maxWidth * 0.45 : constraints.maxWidth * 0.65;
            final double scannerBorderRadius = tablet ? 40 : 25;
            final double cardBorderRadius = tablet ? 50 : 30;
            final double cardPadding = tablet ? 32 : 20;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: cardHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            // Mantendo a parte de cima branca, como no design original
                            color:  theme.colorScheme.onSecondary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(tablet ? 200 : 100),
                              bottomRight: Radius.circular(tablet ? 200 : 100),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: tablet ? 50 : 35),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: tablet ? 32 : 16),
                            child: Container(
                              padding: EdgeInsets.all(cardPadding),
                              decoration: BoxDecoration(
                                // Cor do card vinda do tema
                                color: theme.colorScheme.onPrimary,
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                                // Cor da borda vinda do tema
                                border: Border.all(
                                    color: theme.dividerColor.withOpacity(0.2), width: 1.6),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Place the QR code\nin the area',
                                              // Estilo de texto do tema
                                              style: textTheme.titleLarge?.copyWith(
                                                //fontWeight: FontWeight.bold
                                              ),  
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              'Scanning will start\nautomatically',
                                              // Estilo de texto do tema com opacidade
                                              style: textTheme.bodyMedium?.copyWith(
                                                color: theme.colorScheme.onSurface.withOpacity(0.7)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset('assets/bc.png',
                                          width: 100, height: 90),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: pickImageFromGallery,
                                      borderRadius: BorderRadius.circular(14),
                                      child: DottedBorder(
                                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(14),
                                        dashPattern: const [6, 3],
                                        strokeWidth: 1.5,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            // Cor do botão vinda do tema
                                            color: theme.colorScheme.onPrimary,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/gallery.svg',
                                                  width: 24,
                                                  height: 24,
                                                  colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn)),
                                              const SizedBox(width: 10),
                                              Text(
                                                'From gallery',
                                                // Estilo de texto do tema
                                                style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: tablet ? 40 : 20),
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/frame.svg',
                                  width: scannerSize,
                                  height: scannerSize,
                                  // Cor do frame vinda do tema
                                  colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      scannerBorderRadius),
                                  child: SizedBox(
                                    width: scannerSize * 0.8,
                                    height: scannerSize * 0.8,
                                    child:
                                        MobileScanner(controller: controller),
                                  ),
                                ),
                              ],
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
}