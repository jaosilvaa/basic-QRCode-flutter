import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:qrqrcode/routes.dart'; 
import 'package:qrqrcode/scr/app/main_navigation.dart';
import 'package:qrqrcode/scr/core/theme/app_theme.dart';
import 'package:qrqrcode/scr/ui/settings/controllers/theme_controller.dart';
import 'package:qrqrcode/scr/core/di/injection_container.dart';
import 'package:qrqrcode/scr/core/utils/system_config.dart'; 
import 'package:qrqrcode/scr/core/app/app_providers.dart'; 

final sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prepareSystemUI();
  
  setupInjection(); 

  runApp(
    const AppProviders( 
      child: MyApp(), // 
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final themeMode = context.watch<ThemeController>().themeMode;
    return MaterialApp.router(
      title: 'ScanLinker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      //home: const MainScreen(),
      debugShowCheckedModeBanner: false,
      routerConfig: routes,

    );
  }
}