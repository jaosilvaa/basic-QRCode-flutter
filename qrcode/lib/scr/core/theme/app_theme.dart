import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/core/theme/app_text_styles.dart';

class AppTheme {
  static final TextTheme _baseTextTheme = TextTheme(
    headlineLarge: AppTextStyles.headline1,
    headlineMedium: AppTextStyles.headline2,
    headlineSmall: AppTextStyles.headline3,
    titleLarge: AppTextStyles.headline4,
    titleMedium: AppTextStyles.headline5,
    titleSmall: AppTextStyles.headline6,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.labelSmall,
  );

  static ThemeData get lightTheme {
    final theme = ThemeData.light(useMaterial3: true);
    return theme.copyWith(
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.iconBackgroundDark,
        background: AppColors.lightBackground,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
        outline: AppColors.lightBorderColor,
      ),
      textTheme: GoogleFonts.openSansTextTheme(_baseTextTheme).apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.openSans(
          textStyle: AppTextStyles.headline5?.copyWith(color: Colors.black)
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final theme = ThemeData.dark(useMaterial3: true);
    return theme.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.iconBackgroundDark,
        inverseSurface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black,
        outline: AppColors.borderColor,
      ),
      textTheme: GoogleFonts.openSansTextTheme(_baseTextTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.secondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(textStyle: AppTextStyles.headline5),
      ),
    );
  }
}
