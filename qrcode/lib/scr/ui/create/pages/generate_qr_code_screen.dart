import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/domain/models/enums/qr_style_type.dart';
import 'package:qrqrcode/scr/domain/models/enums/qr_type.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';
import 'package:qrqrcode/scr/ui/create/widgets/custom_form_field.dart';
import 'package:qrqrcode/scr/ui/create/widgets/form_container_new.dart';
import 'package:qrqrcode/scr/ui/create/widgets/generate_button.dart';
import 'package:qrqrcode/scr/ui/settings/controllers/qr_style_controller.dart';
import 'package:qrqrcode/scr/ui/widgets/custom_app_bar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class GenerateQrCodeScreen extends StatefulWidget {
  final QRType qrType;

  const GenerateQrCodeScreen({
    super.key,
    required this.qrType,
  });

  @override
  State<GenerateQrCodeScreen> createState() => _GenerateQrCodeScreenState();
}

class _GenerateQrCodeScreenState extends State<GenerateQrCodeScreen>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final ScreenshotController _screenshotController = ScreenshotController();
  final ScrollController _scrollController = ScrollController();

  // FocusNodes para cada campo
  final FocusNode _textFocus = FocusNode();
  final FocusNode _urlFocus = FocusNode();
  final FocusNode _ssidFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _securityType = 'WPA/WPA2';
  bool _isPasswordObscured = true;

  String qrData = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Listeners para auto-scroll quando cada campo ganha foco
    _textFocus.addListener(() => _handleFocus(_textFocus));
    _urlFocus.addListener(() => _handleFocus(_urlFocus));
    _ssidFocus.addListener(() => _handleFocus(_ssidFocus));
    _passwordFocus.addListener(() => _handleFocus(_passwordFocus));
  }

  @override
  void didChangeMetrics() {
    // ignore: deprecated_member_use
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0) {
      _scrollToFocusedField();
    }
  }

  void _handleFocus(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      _scrollToFocusedField();
    }
  }

  void _scrollToFocusedField() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (!mounted) return;

      FocusNode? activeNode;
      if (_textFocus.hasFocus) {
        activeNode = _textFocus;
      } else if (_urlFocus.hasFocus) {
        activeNode = _urlFocus;
      } else if (_ssidFocus.hasFocus) {
        activeNode = _ssidFocus;
      } else if (_passwordFocus.hasFocus) {
        activeNode = _passwordFocus;
      }

      if (activeNode != null && activeNode.context != null) {
        Scrollable.ensureVisible(
          activeNode.context!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          alignment: 0.2,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    _urlController.dispose();
    _ssidController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();

    _textFocus.dispose();
    _urlFocus.dispose();
    _ssidFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  void _updateQrData() {
    setState(() {
      qrData = _generateQrData();
    });
  }

  String _generateQrData() {
    switch (widget.qrType) {
      case QRType.plainText:
        return _textController.text;

      case QRType.url:
        String url = _urlController.text;
        if (url.isNotEmpty &&
            !url.startsWith('http://') &&
            !url.startsWith('https://')) {
          url = 'https://$url';
        }
        return url;

      case QRType.wifi:
        final ssid = _ssidController.text;
        final password = _passwordController.text;

        if (_securityType == 'NONE') {
          return 'WIFI:S:$ssid;T:nopass;P:;H:false;';
        }

        return 'WIFI:S:$ssid;T:$_securityType;P:$password;H:false;';

      default:
        return '';
    }
  }

  Widget _buildFormFields() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final Color inputFillColor = theme.scaffoldBackgroundColor;
    final Color inputBorderColor = theme.colorScheme.outline;
    final Color menuBackgroundColor = theme.colorScheme.surface;

    switch (widget.qrType) {
      case QRType.plainText:
        return CustomFormField(
          label: "Texto",
          hintText: "Digite seu texto aqui",
          controller: _textController,
          focusNode: _textFocus,
        );

      case QRType.url:
        return CustomFormField(
          label: "URL",
          hintText: "Digite sua URL aqui",
          controller: _urlController,
          focusNode: _urlFocus,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'URL não pode ficar vazia.';
            }
            return null;
          },
        );

      case QRType.wifi:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomFormField(
              label: "SSID",
              hintText: "Nome da rede WI-FI",
              controller: _ssidController,
              focusNode: _ssidFocus,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o SSID';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              "Tipo de Segurança",
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.neutralDarkGrey,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _securityType,
              decoration: InputDecoration(
                filled: true,
                fillColor: inputFillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: inputBorderColor,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: inputBorderColor,
                    width: 1.5,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              dropdownColor: menuBackgroundColor,
              style: textTheme.bodyLarge,
              items: const [
                DropdownMenuItem(
                  value: 'NONE',
                  child: Text('Nenhuma'),
                ),
                DropdownMenuItem(
                  value: 'WEP',
                  child: Text('WEP'),
                ),
                DropdownMenuItem(
                  value: 'WPA/WPA2',
                  child: Text('WPA/WPA2'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _securityType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomFormField(
              label: "Senha",
              hintText: "Senha da rede Wi-Fi",
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: _isPasswordObscured,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
                icon: Icon(
                  _isPasswordObscured ? LucideIcons.eyeOff : LucideIcons.eye,
                  color: AppColors.neutralDarkGrey,
                ),
              ),
              validator: (value) {
                if (_securityType == 'NONE') {
                  return null;
                }
                if (value == null || value.trim().isEmpty) {
                  return 'Informe a senha da rede.';
                }
                return null;
              },
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _shareQrCode() async {
    if (qrData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum QR Code para compartilhar.')),
      );
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/qr_code.png';
    final capture = await _screenshotController.capture();

    if (capture == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao capturar o QR Code.')),
      );
      return;
    }

    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(capture);

    await Share.shareXFiles(
      [XFile(imagePath)],
      text: 'Compartilhe seu QR Code!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isQrGenerated = qrData.isNotEmpty;
    final isDark = theme.brightness == Brightness.dark;

    final topBackgroundColor =
        isDark ? AppColors.white : AppColors.neutralLightGrey;
    final appBarTextColor = AppColors.black;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: topBackgroundColor,
      appBar: CustomAppBar(
        title: "Criar ${QRUtils.getTypeName(widget.qrType)}",
        textColor: appBarTextColor,
        backgroundColor: topBackgroundColor,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Screenshot(
              controller: _screenshotController,
              child: Container(
                color: topBackgroundColor,
                padding: const EdgeInsets.all(12),
                child: qrData.isEmpty
                    ? Image.asset(
                        'assets/193.png',
                        height: 160,
                        fit: BoxFit.contain,
                      )
                    : Consumer<QrStyleController>(
                        builder: (context, styleController, _) {
                          final isModern =
                              styleController.qrStyle == QrStyleType.modern;
                          final eyeShape = isModern
                              ? QrEyeShape.circle
                              : QrEyeShape.square;
                          final dataShape = isModern
                              ? QrDataModuleShape.circle
                              : QrDataModuleShape.square;

                          return QrImageView(
                            data: qrData,
                            size: 180,
                            version: QrVersions.auto,
                            eyeStyle: QrEyeStyle(
                              eyeShape: eyeShape,
                              color: AppColors.black,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: dataShape,
                              color: AppColors.black,
                            ),
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                          );
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: isQrGenerated ? _shareQrCode : null,
            icon: Icon(
              LucideIcons.send,
              color:
                  isQrGenerated ? AppColors.black : AppColors.neutralDarkGrey,
              size: 20,
            ),
            label: Text(
              'Share',
              style: TextStyle(
                color: isQrGenerated
                    ? AppColors.black
                    : AppColors.neutralDarkGrey,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.neutralLightGrey,
              elevation: isQrGenerated ? 4 : 0,
              shadowColor: isQrGenerated
                  ? AppColors.black.withValues(alpha: 0.3)
                  : Colors.transparent,
              fixedSize: const Size(150, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  top: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(31),
                        topRight: Radius.circular(31),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 27,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        const SizedBox(height: 4),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const ClampingScrollPhysics(),
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    FormContainerNew(
                                      children: [_buildFormFields()],
                                    ),
                                    const SizedBox(height: 24),
                                    Center(
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: GenerateButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                true) {
                                              _updateQrData();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      height: keyboardHeight > 0
                                          ? keyboardHeight + 20
                                          : 50,
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
                Positioned(
                  top: 18,
                  left: (MediaQuery.of(context).size.width / 2) -
                      (48.35 / 2),
                  child: Container(
                    width: 48.35,
                    height: 3.69,
                    decoration: BoxDecoration(
                      color: AppColors.neutralGrey950,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
