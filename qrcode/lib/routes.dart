import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qrqrcode/scr/app/main_navigation.dart';
import 'package:qrqrcode/scr/domain/models/enums/qr_type.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/ui/create/pages/create_qr_code_screen.dart';
import 'package:qrqrcode/scr/ui/create/pages/generate_qr_code_screen.dart';
import 'package:qrqrcode/scr/ui/result/pages/result_screen.dart';
import 'package:qrqrcode/scr/ui/saved/pages/qr_code_details_screen.dart';
import 'package:qrqrcode/scr/ui/saved/pages/saved_qr_screen.dart';
import 'package:qrqrcode/scr/ui/scanner/pages/qr_scanner.dart';
import 'package:qrqrcode/scr/ui/settings/pages/qr_style_selection_screen.dart';
import 'package:qrqrcode/scr/ui/settings/pages/settings_screen.dart';
import 'package:qrqrcode/scr/ui/settings/pages/theme_selection_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routes = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/scanner',
  redirect: (context, state) {
    if (state.uri.path == '/') return '/scanner';
    return null;
  },
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: '/scanner',
          builder: (context, state) => const QrScanner(),
          routes: [
            GoRoute(
              path: 'result',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => ResultScreen(result: state.extra as ScanResult),
            ),
          ],
        ),
        GoRoute(
          path: '/create',
          builder: (context, state) => const CreateQrCodeScreen(),
          routes: [
            GoRoute(
              path: 'generate',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => GenerateQrCodeScreen(qrType: state.extra as QRType),
            ),
          ],
        ),
        GoRoute(
          path: '/saved',
          builder: (context, state) => const SavedQrScreen(),
          routes: [
            GoRoute(
              path: 'details/:id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => QRcodeInfos(result: state.extra as ScanResult),
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'theme',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const ThemeSelectionScreen(),
            ),
            GoRoute(
              path: 'style',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const QrStyleSelectionScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);