import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/domain/models/enums/qr_type.dart';
import 'package:qrqrcode/scr/ui/create/pages/generate_qr_code_screen.dart';
import 'package:qrqrcode/scr/ui/widgets/custom_app_bar.dart';
import 'package:qrqrcode/scr/core/theme/app_text_styles.dart';

class CreateQrCodeScreen extends StatelessWidget {
  const CreateQrCodeScreen({super.key});

  void _navigateToGenerateScreen(BuildContext context, QRType type) {
    context.push('/create/generate', extra: type);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Create QR Code",
        backgroundColor: theme.scaffoldBackgroundColor,
        textColor: isDark ? AppColors.white : AppColors.black,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.white : AppColors.black,
        ),
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: AppTextStyles.headline4.copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'Select an option to create\nyour '),
                  TextSpan(
                    text: 'QR Code',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: AppTextStyles.headline4.fontWeight,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 163 / 188,
                children: [
                  _QrCodeOptionCard(
                    icon: LucideIcons.type,
                    text: 'Create new\nText',
                    isDark: isDark,
                    onTap: () => _navigateToGenerateScreen(context, QRType.plainText),
                  ),
                  _QrCodeOptionCard(
                    icon: LucideIcons.wifi,
                    text: 'Create new\nWifi',
                    isDark: isDark,
                    onTap: () => _navigateToGenerateScreen(context, QRType.wifi),
                  ),
                  _QrCodeOptionCard(
                    icon: LucideIcons.link,
                    text: 'Create new\nURL',
                    isDark: isDark,
                    onTap: () => _navigateToGenerateScreen(context, QRType.url),
                  ),
                  _QrCodeOptionCard(
                    icon: LucideIcons.userRound,
                    text: 'Create new\nContact',
                    isDark: isDark,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Função de Contato em desenvolvimento!')),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _QrCodeOptionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  final VoidCallback onTap;

  const _QrCodeOptionCard({
    required this.icon,
    required this.text,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final cardBackgroundColor = isDark 
        ? AppColors.neutralGrey950 
        : AppColors.neutralLightGrey;
    
    final circleBackgroundColor = isDark 
        ? AppColors.white 
        : AppColors.neutralMidLightGrey;
    
    final iconColor = AppColors.black;
    
    final textColor = isDark 
        ? AppColors.white 
        : AppColors.neutralGrey900;

    return Material(
      color: cardBackgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          HapticFeedback.lightImpact();
          Future.delayed(const Duration(milliseconds: 290), () { 
            onTap();
          });
        },
        splashFactory: InkRipple.splashFactory,
        // ===============================================
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 58.75 / 2,
                backgroundColor: circleBackgroundColor,
                child: Icon(
                  icon,
                  size: 24.55,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 23),
              Text(
                text,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}