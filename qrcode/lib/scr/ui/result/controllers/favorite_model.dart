import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/data/services/local_storageService.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';

class FavoritesController extends ChangeNotifier {
  final LocalStorageService _localStorageService;
  List<ScanResult> _favoriteQrCodes = [];
  bool _isLoading = false;

  List<ScanResult> get favoriteQrCodes => _favoriteQrCodes;
  bool get isLoading => _isLoading;

  FavoritesController(this._localStorageService) {
    updateFromService();
  }

  void updateFromService() {
    _updateFromService();
  }

  Future<void> _updateFromService() async {
    _isLoading = true;
    notifyListeners();
    _favoriteQrCodes = await _localStorageService.getSavedQrCodes();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addFavorite(ScanResult result) async {
    return await _localStorageService.saveQrCode(result);
  }

  Future<void> removeFavorite(String id) async {
    await _localStorageService.removeQrCode(id);
  }

  // Corrigido: Agora usa a igualdade de valor
  bool isFavorite(ScanResult result) {
    return _favoriteQrCodes.any((fav) => fav == result);
  }

  ScanResult? findFavoriteByRawValue(String rawValue) {
    try {
      return _favoriteQrCodes.firstWhere((fav) => fav.rawValue == rawValue);
    } catch (e) {
      return null;
    }
  }
}