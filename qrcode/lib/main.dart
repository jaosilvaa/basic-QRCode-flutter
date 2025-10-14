import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/app/main_navigation.dart';
import 'package:qrqrcode/scr/core/theme/app_theme.dart';
import 'package:qrqrcode/scr/data/services/local_storageService.dart';
import 'package:qrqrcode/scr/ui/result/controllers/favorite_model.dart';
import 'package:qrqrcode/scr/ui/saved/controllers/saved_qr_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
      
        ChangeNotifierProvider(
          create: (_) => LocalStorageService(),
        ),
        ChangeNotifierProxyProvider<LocalStorageService, FavoritesController>(
          create: (context) => FavoritesController(
            Provider.of<LocalStorageService>(context, listen: false),
          ),
          update: (context, localStorageService, favoritesController) => favoritesController!..updateFromService(),
        ),

        ChangeNotifierProxyProvider<LocalStorageService, SavedQrController>(
          create: (context) => SavedQrController(
            Provider.of<LocalStorageService>(context, listen: false),
          ),
          update: (context, localStorageService, savedQrController) => savedQrController!..updateFromService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
    );
  }
}