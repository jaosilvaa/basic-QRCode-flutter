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
    updateFromService();
  }

  // Adiciona o método público updateFromService para ser chamado pelo Provider
  void updateFromService() {
    _updateSavedQrCodes();
  }

  Future<void> _updateSavedQrCodes() async {
    _isLoading = true;
    notifyListeners();
    _savedQrCodes = await _localStorageService.getSavedQrCodes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> removeQrCode(String id) async {
    await _localStorageService.removeQrCode(id);
  }
}