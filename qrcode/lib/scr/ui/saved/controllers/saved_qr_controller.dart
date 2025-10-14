import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/data/services/local_storageService.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';

class SavedQrController extends ChangeNotifier {
  final LocalStorageService _localStorageService;
  List<ScanResult> _savedQrCodes = [];
  bool _isLoading = false;

  List<ScanResult> get savedQrCode => _savedQrCodes;
  bool get isLoading => _isLoading;

  SavedQrController(this._localStorageService) {
    loadSavedQrCodes();
    _localStorageService.addListener(loadSavedQrCodes);
  }

  @override
  void dispose() {
    _localStorageService.removeListener(loadSavedQrCodes);
    super.dispose();
  }

  Future<void> loadSavedQrCodes() async{
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    _savedQrCodes = await _localStorageService.getSavedQrCodes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeQrCode(String id) async {
    await _localStorageService.removeQrCode(id);
  }
}