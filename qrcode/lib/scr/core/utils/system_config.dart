import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart'; 

Future<void> prepareSystemUI() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
}

void updateSystemUI(ThemeMode mode) {
  final isDark = mode == ThemeMode.dark;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,

      systemNavigationBarColor:
          isDark ? AppColors.black : AppColors.white, 
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor:
          isDark ? AppColors.black : AppColors.white,
    ),
  );
}