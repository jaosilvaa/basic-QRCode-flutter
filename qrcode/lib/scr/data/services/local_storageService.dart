import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService extends ChangeNotifier {
  static const String _savedQrCodesKey = 'saved_qr_codes';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<bool> saveQrCode(ScanResult result) async {
    final prefs = await _prefs;
    final List<ScanResult> currentSavedCodes = await getSavedQrCodes();

    if (currentSavedCodes.contains(result)) {
      return false;
    }
    currentSavedCodes.add(result);

    final List<String> jsonStringList = currentSavedCodes
        .map((res) => jsonEncode(res.toJson()))
        .toList();
    await prefs.setStringList(_savedQrCodesKey, jsonStringList);
    notifyListeners(); 
    return true; 
  }

  Future<List<ScanResult>> getSavedQrCodes() async {
    final prefs = await _prefs;
    final List<String>? jsonStringList = prefs.getStringList(_savedQrCodesKey);

    if (jsonStringList == null) {
      return [];
    }

    return jsonStringList
        .map((jsonString) => ScanResult.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  Future<void> removeQrCode(String id) async {
    final prefs = await _prefs;
    final List<ScanResult> currentSavedCodes = await getSavedQrCodes();

    currentSavedCodes.removeWhere((res) => res.id == id);

    final List<String> jsonStringList = currentSavedCodes
        .map((res) => jsonEncode(res.toJson()))
        .toList();
    await prefs.setStringList(_savedQrCodesKey, jsonStringList);
    notifyListeners(); 
  }

  Future<bool> isQrCodeSaved(ScanResult result) async {
    final List<ScanResult> savedCodes = await getSavedQrCodes();
    return savedCodes.contains(result);
  }
}