import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/data/services/settings_service.dart';
import 'package:qrqrcode/scr/domain/models/enums/qr_style_type.dart';

class QrStyleController extends ChangeNotifier{
  final SettingsService _settingsService;
  QrStyleType _qrStyle = QrStyleType.modern;

  QrStyleType get qrStyle => _qrStyle;

  QrStyleController(this._settingsService){
    _loadQrStyle();
  }

  Future<void> _loadQrStyle() async{
    _qrStyle = await _settingsService.loadQrStyle();
    notifyListeners();
  }

  Future<void> updateQrStyle(QrStyleType newStyle) async{
    if (_qrStyle == newStyle)return;

    _qrStyle = newStyle;
    notifyListeners();
    await _settingsService.saveQrStyle(newStyle);
  }
}