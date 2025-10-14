import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/app/main_navigation.dart';
import 'package:qrqrcode/scr/core/theme/app_theme.dart';
import 'package:qrqrcode/scr/data/services/local_storageService.dart';
import 'package:qrqrcode/scr/ui/result/controllers/favorite_model.dart';
import 'package:qrqrcode/scr/ui/saved/controllers/saved_qr_controller.dart';

final sl = GetIt.instance;

void setup(){
  sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService());

  sl.registerLazySingleton<FavoritesController>(() => FavoritesController(sl()));
  sl.registerLazySingleton<SavedQrController>(() => SavedQrController(sl()));
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  setup();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoritesController>(create: (_) => sl<FavoritesController>()),
        ChangeNotifierProvider<SavedQrController>(create: (_) => sl<SavedQrController>())     
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
    );
  }
}