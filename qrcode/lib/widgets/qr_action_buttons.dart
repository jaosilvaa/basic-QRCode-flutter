import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qrqrcode/models/qr_type.dart';
import 'package:qrqrcode/utils/wifi_qr_manager.dart';
import 'package:qrqrcode/widgets/custom_qr_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/scan_result.dart';

class QRActionButtons extends StatelessWidget {
  final ScanResult result;

  const QRActionButtons({
    super.key,
    required this.result,
  });

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: result.rawValue));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copiado para a área de transferência')),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link')),
      );
    }
  }

 Future<void> _connectToWifi(BuildContext context, String wifiData) async {
    // Usar o WiFiManager para conectar
    await WiFiManager.connectToWifi(context, wifiData);
  }
  Map<String, dynamic> _getActionDetails(BuildContext context) {
    IconData icon = Iconsax.copy;
    String label = 'Copiar';
    VoidCallback action = () {};

    switch (result.type) {
      case QRType.url:
        icon = Iconsax.global;
        label = 'Navegar';
        action = () => _launchURL(context, result.rawValue);
        break;
      case QRType.wifi:
        icon = Iconsax.wifi;
        label = 'Conectar';
        action = () => _connectToWifi(context, result.rawValue);
        break;
      case QRType.phone:
        icon = Iconsax.call;
        label = 'Ligar';
        action = () => _launchURL(context, result.rawValue);
        break;
      case QRType.email:
        icon = Iconsax.sms;
        label = 'Email';
        action = () => _launchURL(context, result.rawValue);
        break;
      case QRType.sms:
        icon = Iconsax.message;
        label = 'SMS';
        action = () => _launchURL(context, result.rawValue);
        break;
      default:
        icon = Iconsax.document_copy;
        label = 'Copiar';
        action = () {};
        break;
    }

    return {
      'icon': icon,
      'label': label,
      'action': action,
    };
  }

  @override
  Widget build(BuildContext context) {
    final actionDetails = _getActionDetails(context);

    return Column(
      children: [
        if (result.type != QRType.plainText && result.type != QRType.unknown)
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomQRButton(
                  icon: Iconsax.document_copy,
                  label: 'Copiar',
                  iconColor: const Color(0xffBBFB4C),
                  onPressed: () => _copyToClipboard(context),
                ),
                const SizedBox(width: 5),
                CustomQRButton(
                  icon: actionDetails['icon'],
                  label: actionDetails['label'],
                  iconColor: const Color(0xffBBFB4C),
                  onPressed: actionDetails['action'],
                ),
              ],
            ),
          )
        else
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => _copyToClipboard(context),
              child: const Text(
                'Copiar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
