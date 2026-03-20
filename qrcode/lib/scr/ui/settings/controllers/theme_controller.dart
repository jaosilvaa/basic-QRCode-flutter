import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/data/services/settings_service.dart';
import 'package:qrqrcode/scr/core/utils/system_config.dart';

class ThemeController extends ChangeNotifier {
  final SettingsService _settingsService;

  ThemeController(this._settingsService) {
    _loadTheme();
  }

  ThemeMode _themeMode = ThemeMode.dark; 
  ThemeMode get themeMode => _themeMode;

  Future<void> _loadTheme() async {
    _themeMode = await _settingsService.loadThemeMode();
    updateSystemUI(_themeMode);
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newMode) async {
    if (newMode == null) return;

    _themeMode = newMode;
    await _settingsService.saveThemeMode(newMode);
    
    updateSystemUI(newMode);
    
    notifyListeners();
  }
}