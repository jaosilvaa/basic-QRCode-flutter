import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrqrcode/scr/domain/models/qr_type.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';
import 'package:qrqrcode/scr/ui/create/widgets/custom_form_field.dart';
import 'package:qrqrcode/scr/ui/create/widgets/form_container_new.dart';
import 'package:qrqrcode/scr/ui/create/widgets/generate_button.dart';
import 'package:qrqrcode/scr/ui/widgets/custom_appBar_new.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class GenerateQrCodeScreenNew extends StatefulWidget {
  final QRType qrType;

  const GenerateQrCodeScreenNew({super.key, required this.qrType});

  @override
  State<GenerateQrCodeScreenNew> createState() =>
      _GenerateQrCodeScreenNewState();
}

class _GenerateQrCodeScreenNewState extends State<GenerateQrCodeScreenNew> {
  final _formKey = GlobalKey<FormState>();
  final ScreenshotController _screenshotController = ScreenshotController();

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _securityType = 'WPA/WPA2';
  bool _isPasswordObscured = true;
  String qrData = '';

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();
    _ssidController.dispose();
    _passwordController.dispose();
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
        return 'WIFI:S:$ssid;T:$_securityType;P:$password;H:false;';
      default:
        return '';
    }
  }

  Widget _buildFormFields() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    switch (widget.qrType) {
      case QRType.plainText:
        return CustomFormField(
          label: "Texto",
          hintText: "Digite seu texto aqui",
          controller: _textController,
        );

      case QRType.url:
        return CustomFormField(
          label: "URL",
          hintText: "Digite sua URL aqui",
          controller: _urlController,
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
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _securityType,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: theme.colorScheme.outline, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: theme.colorScheme.outline, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 1.5),
                ),
              ),
              dropdownColor: const Color.fromARGB(255, 32, 32, 32),
              style: textTheme.bodyLarge,
              items: const [
                DropdownMenuItem(
                  value: 'NONE',
                  child: Text('Nenhuma', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'WEP',
                  child: Text('WEP', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'WPA/WPA2',
                  child:
                      Text('WPA/WPA2', style: TextStyle(color: Colors.white)),
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
              obscureText: _isPasswordObscured,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
                icon: Icon(
                  _isPasswordObscured
                      ? LucideIcons.eyeOff
                      : LucideIcons.eye,
                ),
              ),
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

  String _getAppBarTitle() {
    switch (widget.qrType) {
      case QRType.plainText:
        return 'Create QR Code';
      case QRType.url:
        return 'Create URL';
      case QRType.wifi:
        return 'Create Wifi';
      default:
        return 'Create QR Code';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isQrGenerated = qrData.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.colorScheme.onSecondary,
      appBar: CustomAppBarNew(
        title: "Criar ${QRUtils.getTypeName(widget.qrType)}",
        textColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.onSecondary,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black),
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
                color: theme.colorScheme.onSecondary,
                padding: const EdgeInsets.all(12),
                child: qrData.isEmpty
                    ? Image.asset(
                        'assets/193.png',
                        height: 160,
                        fit: BoxFit.contain,
                      )
                    : QrImageView(
                        data: qrData,
                        size: 180,
                        version: QrVersions.auto,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: isQrGenerated ? _shareQrCode : null,
            icon: Icon(
              LucideIcons.send,
              color: isQrGenerated
                  ? theme.colorScheme.onPrimary
                  : theme.disabledColor,
              size: 20,
            ),
            label: Text(
              'Share',
              style: TextStyle(
                color: isQrGenerated
                    ? theme.colorScheme.onPrimary
                    : theme.disabledColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.onSecondary,
              disabledBackgroundColor:
                  theme.colorScheme.onPrimary.withOpacity(0.2),
              elevation: isQrGenerated ? 4 : 0,
              shadowColor: isQrGenerated
                  ? theme.colorScheme.onPrimary.withOpacity(0.3)
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
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: const BorderRadius.only(
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
                      color: theme.colorScheme.background,
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
                                              setState(() {
                                                qrData = _generateQrData();
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
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
                  left: (MediaQuery.of(context).size.width / 2) - (48.35 / 2),
                  child: Container(
                    width: 48.35,
                    height: 3.69,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
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
