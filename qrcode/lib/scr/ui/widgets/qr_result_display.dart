import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qrqrcode/scr/core/theme/app_text_styles.dart';
import 'package:qrqrcode/scr/domain/models/qr_type.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/domain/parser/qr_parser.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';
import 'package:qrqrcode/scr/ui/widgets/custom_display_field.dart'; 

class QrResultDisplay extends StatefulWidget {
  final ScanResult result;
  const QrResultDisplay({super.key, required this.result});

  @override
  State<QrResultDisplay> createState() => _QrResultDisplayState();
}

class _QrResultDisplayState extends State<QrResultDisplay> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          _buildResultFields(),
        ],
      );
    
  }

  Widget _buildResultFields(){
    switch (widget.result.type){
      case QRType.wifi:
        try{
          final wifiData = QRParser.parseWifi(widget.result.rawValue);
          final ssid = wifiData['S'] ?? 'N/A';
          final security = wifiData['T'] ?? 'N/A';
          final password = wifiData['P'] ?? '';

          return Column(
            children: [
              CustomDisplayField(label: "SSID", value: ssid),
              const SizedBox(height: 16),
              CustomDisplayField(label: "Tipo de Segurança", value: security),
              if(password.isNotEmpty) ...[
                const SizedBox(height: 16),
                CustomDisplayField(
                  label: "Senha", 
                  value: password,
                  obscureText: _isPasswordObscured,
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                    icon: Icon(
                      _isPasswordObscured ? LucideIcons.eyeOff : LucideIcons.eye,
                      color: Colors.grey,
                      size: 20,
                    )
                  ),
                )
              ],
            ],
          );
        }catch(e){
          return CustomDisplayField(label: "Dados Inválidos", value: widget.result.rawValue);
        }
      case QRType.plainText:
      default:
        return CustomDisplayField(label: "Texto", value: widget.result.rawValue);
    }
  }
}