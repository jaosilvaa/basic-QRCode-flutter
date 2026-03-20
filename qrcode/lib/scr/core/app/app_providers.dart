import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/core/di/injection_container.dart'; 
import 'package:qrqrcode/scr/ui/result/controllers/favorite_model.dart';
import 'package:qrqrcode/scr/ui/saved/controllers/saved_qr_controller.dart';
import 'package:qrqrcode/scr/ui/settings/controllers/qr_style_controller.dart';
import 'package:qrqrcode/scr/ui/settings/controllers/theme_controller.dart';


class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<ThemeController>()),
        ChangeNotifierProvider(create: (_) => sl<FavoritesController>()),
        ChangeNotifierProvider(create: (_) => sl<SavedQrController>()),
        ChangeNotifierProvider(create: (_) => sl<QrStyleController>()),
      ],
      child: child,
    );
  }
}