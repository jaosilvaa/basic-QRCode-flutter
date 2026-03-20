import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/domain/models/enums/qr_style_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {

  static const String _themeKey = 'theme_mode';
  static const String _qrStyleKey = 'qr_style_mode';

  Future<ThemeMode> loadThemeMode() async{
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    switch (themeString){
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.dark; 
    }
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async{
    final prefs = await SharedPreferences.getInstance();
    String themeString;
    switch (themeMode){
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'dark'; 
        break;
    }

    await prefs.setString(_themeKey, themeString);
  }


  Future<QrStyleType> loadQrStyle() async{
    final prefs = await SharedPreferences.getInstance();
    final styleString = prefs.getString(_qrStyleKey);

    switch (styleString){
      case 'traditional':
        return QrStyleType.traditional;
      case 'modern':
      default:
        return QrStyleType.modern;
    }
  }

  Future<void> saveQrStyle(QrStyleType style) async{
    final prefs = await SharedPreferences.getInstance();
    String styleString;

    switch (style){
      case QrStyleType.traditional:
        styleString = 'tradicional';
        break;
      case QrStyleType.modern:
        styleString = 'modern';
        break;
    }
    await prefs.setString(_qrStyleKey, styleString);
  }
}