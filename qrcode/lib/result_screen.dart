import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
const bgColor = Color(0xfffafafa);

class ResultScreen extends StatelessWidget {
  final String code;
  final Function() closeScreen;
  
  const ResultScreen({super.key, required this.code, required this.closeScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('QR Scanner'),
        leading: IconButton(
          onPressed: () {
            closeScreen();
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            QrImageView(data: '', size: 150, version: QrVersions.auto),

            Text(
              'Scanned Result',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            Text(
              code,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                letterSpacing: 1,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                },
                child: Text(
                  'Copy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}