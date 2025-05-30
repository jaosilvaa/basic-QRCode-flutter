import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:qrqrcode/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
    );
  }
}
