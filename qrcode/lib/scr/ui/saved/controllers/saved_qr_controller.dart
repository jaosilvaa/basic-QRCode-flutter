import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/data/services/local_storageService.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';

class SavedQrController extends ChangeNotifier {
  final LocalStorageService _localStorageService;


  
  List<ScanResult> _savedQrCodes = [];
  

  List<ScanResult> _tempQrCodes = [];
  
  bool _isLoading = true; 

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


  void prepareScreen() {


    _savedQrCodes = [];
    _isLoading = true;
  }

  Future<void> initialize() async {
    
    _tempQrCodes = await _localStorageService.getSavedQrCodes();
    
    if (_tempQrCodes.isEmpty) {

      _savedQrCodes = [];
      _isLoading = false;
      notifyListeners();
    } else {
      
      _savedQrCodes = []; 
      _isLoading = true;
      notifyListeners(); 
      
      await Future.delayed(const Duration(milliseconds: 600));
      
      _savedQrCodes = List.from(_tempQrCodes);
      _isLoading = false;
      notifyListeners(); 
      
      _tempQrCodes = [];
    }
  }

  Future<void> loadSavedQrCodes() async {
    if (_isLoading) return;
    
    _tempQrCodes = await _localStorageService.getSavedQrCodes();
    
    if (_tempQrCodes.isEmpty) {
      _savedQrCodes = [];
      _isLoading = false;
      notifyListeners();
    } else {
      _savedQrCodes = [];
      _isLoading = true;
      notifyListeners();
      
      await Future.delayed(const Duration(milliseconds: 600));
      
      _savedQrCodes = List.from(_tempQrCodes);
      _isLoading = false;
      notifyListeners();
      
    
      _tempQrCodes = [];
    }
  }

  Future<void> removeQrCode(String id) async {
    await _localStorageService.removeQrCode(id);
  }
}