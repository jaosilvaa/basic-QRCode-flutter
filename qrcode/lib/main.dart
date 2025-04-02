import 'package:flutter/material.dart';
import 'package:qrqrcode/screens/home/qr_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        )
      ),
      home: const QrScanner(),
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
    );
  }

}