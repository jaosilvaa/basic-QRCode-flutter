import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/ui/settings/pages/qr_style_selection_screen.dart';
import 'package:qrqrcode/scr/ui/settings/pages/theme_selection_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    Color withOpacity(Color base, double opacity) =>
        base.withValues(alpha: opacity);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.black : AppColors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.white : AppColors.black,
        ),
        title: Text(
          'Configs',
          style: GoogleFonts.roboto(
            color: isDark ? AppColors.white : AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: textTheme.titleMedium?.copyWith(
                color: withOpacity(theme.colorScheme.onSurface, 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    tileColor: theme.colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    leading: Icon(
                      LucideIcons.sunMoon,
                      color: withOpacity(
                          theme.colorScheme.onSurface, 0.8),
                    ),
                    title: Text(
                      'Theme',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Iconsax.arrow_right_3,
                      size: 20,
                      color: withOpacity(
                          theme.colorScheme.onSurface, 0.6),
                    ),
                    onTap: () {
                      context.push('/settings/theme');
                    },
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    indent: 50,
                    endIndent: 20,
                    color: withOpacity(
                        theme.colorScheme.onSurface, 0.1),
                  ),
                  ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    leading: Icon(
                      Iconsax.scan_barcode,
                      color: withOpacity(
                          theme.colorScheme.onSurface, 0.8),
                    ),
                    title: Text(
                      'QR Style',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Iconsax.arrow_right_3,
                      size: 20,
                      color: withOpacity(
                          theme.colorScheme.onSurface, 0.6),
                    ),
                    onTap: () {
                      context.push('/settings/style');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
