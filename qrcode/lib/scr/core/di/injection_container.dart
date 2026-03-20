import 'package:get_it/get_it.dart';
import 'package:qrqrcode/scr/data/services/settings_service.dart';
import 'package:qrqrcode/scr/data/services/local_storage_service.dart';
import 'package:qrqrcode/scr/ui/result/controllers/favorite_model.dart';
import 'package:qrqrcode/scr/ui/saved/controllers/saved_qr_controller.dart';
import 'package:qrqrcode/scr/ui/settings/controllers/qr_style_controller.dart';
import 'package:qrqrcode/scr/ui/settings/controllers/theme_controller.dart';


final sl = GetIt.instance;

void setupInjection() {
  
  sl.registerLazySingleton<SettingsService>(() => SettingsService()); 
  sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  sl.registerLazySingleton<ThemeController>(() => ThemeController(sl()));
  sl.registerLazySingleton<FavoritesController>(() => FavoritesController(sl()));
  sl.registerLazySingleton<SavedQrController>(() => SavedQrController(sl()));
  sl.registerLazySingleton<QrStyleController>(() => QrStyleController(sl()));
}