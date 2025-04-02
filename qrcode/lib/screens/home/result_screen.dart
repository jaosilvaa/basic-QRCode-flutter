import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrqrcode/utils/qr_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/scan_result.dart';
import '../../../widgets/qr_action_buttons.dart';

const bgColor = Color(0xfffafafa);

class ResultScreen extends StatelessWidget {
  final ScanResult result;
  final Function() closeScreen;
  
  const ResultScreen({
    super.key, 
    required this.result, 
    required this.closeScreen
  });
  
  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri uri = Uri.parse(urlString);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening link: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('QR Result'),
        leading: IconButton(
          onPressed: () {
            closeScreen();
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // QR Code Preview
            QrImageView(
              data: result.rawValue, 
              size: 150, 
              version: QrVersions.auto,
            ),
            const SizedBox(height: 20),
            
            // Type indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                QRUtils.getTypeName(result.type),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Scanned content
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  result.rawValue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Action buttons
            QRActionButtons(
              result: result,
              onLaunchUrl: () => _launchURL(context, result.rawValue),
            ),
          ],
        ),
      ),
    );
  }
}