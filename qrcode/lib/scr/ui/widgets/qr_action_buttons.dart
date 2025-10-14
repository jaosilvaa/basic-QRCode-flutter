import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qrqrcode/scr/domain/models/qr_type.dart';
import 'package:qrqrcode/scr/shared/utils/wifi_qr_manager.dart';
import 'package:qrqrcode/scr/ui/widgets/custom_qr_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/models/scan_result.dart';

class QRActionButtons extends StatelessWidget {
  final ScanResult result;

  const QRActionButtons({
    super.key,
    required this.result,
  });

  Future<void> _copyToClipboard(BuildContext context) async {
  await Clipboard.setData(ClipboardData(text: result.rawValue));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Copiado para a área de transferência'),
      backgroundColor: DefaultSelectionStyle.defaultColor, 
      duration: const Duration(seconds: 2), 
    ),
  );
}


  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link')),
      );
    }
  }

 Future<void> _connectToWifi(BuildContext context, String wifiData) async {
    // Usa o WiFiManager para conectar
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
        icon = LucideIcons.wifi;
        label = 'Conectar';
        action = () => _connectToWifi(context, result.rawValue);
        break;
     // case QRType.phone:
      //  icon = Iconsax.call;
      //  label = 'Ligar';
     //   action = () => _launchURL(context, result.rawValue);
     //   break;
      case QRType.email:
        icon = Iconsax.sms;
        label = 'Email';
        action = () => _launchURL(context, result.rawValue);
        break;
     // case QRType.sms:
     //   icon = Iconsax.message;
     //   label = 'SMS';
     //   action = () => _launchURL(context, result.rawValue);
    //    break;
      default:
        icon = Iconsax.global_search;
        label = 'Pesquisar';
        action = () => _launchURL(context, "https://www.google.com/search?q="+result.rawValue);
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

    return Row(
        children: [
          Expanded(
            child: CustomQRButton(icon: Iconsax.copy, label: "Copiar", onPressed: ()=> _copyToClipboard(context)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomQRButton(icon: actionDetails['icon'], label: actionDetails['label'], onPressed: actionDetails['action'])
          )
        ],
      );
    
  }
}
