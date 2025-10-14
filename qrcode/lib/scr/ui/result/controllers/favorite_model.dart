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
    loadFavorites();
    _localStorageService.addListener(loadFavorites);
  }

  @override
  void dispose() {
    _localStorageService.removeListener(loadFavorites);
    super.dispose();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    _favoriteQrCodes = await _localStorageService.getSavedQrCodes();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addFavorite(ScanResult result) async {
    final wasSaved = await _localStorageService.saveQrCode(result);
    return wasSaved;
  }

  Future<void> removeFavorite(String id) async {
    await _localStorageService.removeQrCode(id);
  }

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