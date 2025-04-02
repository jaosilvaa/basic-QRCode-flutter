import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrqrcode/models/qr_type.dart';

import '../models/scan_result.dart';

class QRActionButtons extends StatelessWidget {
  final ScanResult result;
  final VoidCallback onLaunchUrl;

  const QRActionButtons({
    super.key,
    required this.result,
    required this.onLaunchUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: result.rawValue));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            child: const Text(
              'Copy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        
        // Contextual buttons based on QR type
        if (result.type == QRType.url)
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: onLaunchUrl,
              child: const Text(
                'Open in Browser',
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