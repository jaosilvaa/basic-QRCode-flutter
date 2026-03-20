import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/core/theme/app_text_styles.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

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
      const Color mainSurface = AppColors.white;
      final theme = ThemeData.light(useMaterial3: true);

      return theme.copyWith(
        scaffoldBackgroundColor: mainSurface,

        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.neutralLightGrey,
          surface: mainSurface,
          tertiary: AppColors.neutralMidLightGrey,
          onPrimary: AppColors.black,
          onSecondary: AppColors.neutralGrey900,
          onSurface: AppColors.neutralGrey900,
          outline: AppColors.neutralBaseGrey,
          error: AppColors.error,
        ),

      textTheme: GoogleFonts.openSansTextTheme(_baseTextTheme).apply(
        bodyColor: AppColors.neutralGrey900,
        displayColor: AppColors.black,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: mainSurface,
        foregroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        iconTheme: const IconThemeData(color: AppColors.black),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: mainSurface,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mainSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.neutralDarkGrey),
        labelStyle: const TextStyle(color: AppColors.neutralDarkGrey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.neutralBaseGrey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: mainSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.neutralBaseGrey,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {

    const Color darkSurface = AppColors.black;
    final theme = ThemeData.dark(useMaterial3: true);

    return theme.copyWith(
      scaffoldBackgroundColor: darkSurface,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.neutralGrey950,
        surface: darkSurface,
        tertiary: AppColors.black,
        onPrimary: AppColors.black,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        outline: AppColors.neutralGrey900,
        error: AppColors.error,
      ),

      textTheme: GoogleFonts.openSansTextTheme(_baseTextTheme).apply(
        bodyColor: AppColors.white,
        displayColor: AppColors.white,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),

          systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.black,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: darkSurface,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.neutralDarkGrey),
        labelStyle: const TextStyle(color: AppColors.neutralDarkGrey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.neutralGrey900, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.neutralBaseGrey,
        elevation: 0,
      ),
    );
  }
}
