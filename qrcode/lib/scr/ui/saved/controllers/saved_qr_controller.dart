import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/data/services/local_storage_service.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';

class SavedQrController extends ChangeNotifier {
  final LocalStorageService _localStorageService;
  
  // LISTA PRINCIPAL: Usada pelo ListView (só preenchida DEPOIS do shimmer)
  List<ScanResult> _savedQrCodes = [];
  
  // LISTA TEMPORÁRIA: Armazena os dados carregados durante o shimmer
  List<ScanResult> _tempQrCodes = [];
  
  bool _isLoading = false; 
  bool _isRemoving = false; 
  bool _isEditing = false; 

  List<ScanResult> get savedQrCode => _savedQrCodes;
  bool get isLoading => _isLoading;

  SavedQrController(this._localStorageService) {
    _localStorageService.addListener(_onStorageChanged);
  }
  
  void _onStorageChanged() {
    //Só recarrega se não estiver removendo E NEM editando
    if (!_isRemoving && !_isEditing) {
      loadSavedQrCodes();
    }
  }

  @override
  void dispose() {
    _localStorageService.removeListener(_onStorageChanged);
    super.dispose();
  }

   int get shimmerItemCount {
    if (_tempQrCodes.isNotEmpty) {
      return _tempQrCodes.length;
    }
    return 4;
  }

  Future<void> prepareScreen() async {
    _savedQrCodes = [];
    _tempQrCodes = await _localStorageService.getSavedQrCodes();
    
    if (_tempQrCodes.isEmpty) {
      _isLoading = false; 
    } else {
      _isLoading = true; 
    }
  }

  Future<void> initialize() async {
    if (_tempQrCodes.isEmpty) {
      return;
    }
    
    _savedQrCodes = [];
    _isLoading = true;
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    _savedQrCodes = List.from(_tempQrCodes);
    _isLoading = false;
    notifyListeners(); 
    
    _tempQrCodes = [];
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
    _isRemoving = true;
    
    _savedQrCodes.removeWhere((qr) => qr.id == id);
    
    if (_savedQrCodes.isEmpty) {
      _isLoading = false;
    }
    
    notifyListeners();
    
    await _localStorageService.removeQrCode(id);
    
    _isRemoving = false;
  }

  Future<void> saveQrCode(ScanResult result) async{
    _isEditing = true;
    final exists = _savedQrCodes.any((item) => item.id == result.id);
    if(!exists){
      _savedQrCodes.add(result);
      notifyListeners();
      await _localStorageService.saveQrCode(result);
      _isEditing = false;
    }
  }

  Future<void> renameQrCode(String id, String newName) async {
    _isEditing = true;

    final index = _savedQrCodes.indexWhere((q) => q.id == id);
    if (index != -1) {
      final updatedItem = _savedQrCodes[index].copyWith(customName: newName);

      _savedQrCodes[index] = updatedItem;
      notifyListeners();

      await _localStorageService.updateQrCode(updatedItem);
    }
    _isEditing = false;
  }
}