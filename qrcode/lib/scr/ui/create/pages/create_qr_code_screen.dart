import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qrqrcode/scr/domain/models/qr_type.dart';
import 'package:qrqrcode/scr/ui/create/pages/generate_qr_code_screen_new.dart';
import 'package:qrqrcode/scr/ui/widgets/custom_appBar_new.dart';
import 'package:qrqrcode/scr/core/theme/app_text_styles.dart';

class CreateQrCodeScreen extends StatelessWidget {
  const CreateQrCodeScreen({super.key});

  void _navigateToGenerateScreen(BuildContext context, QRType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerateQrCodeScreenNew(qrType: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBarNew(
        title: "Create QR Code",
        backgroundColor: theme.colorScheme.background,
        textColor: theme.colorScheme.onBackground,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
      ),
      drawer: Drawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: AppTextStyles.headline4.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
                children: <TextSpan>[
                  const TextSpan(text: 'Select an option to create\nyour '),
                  TextSpan(
                    text: 'QR Code',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
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
                    iconBackgroundColor: theme.colorScheme.surface,
                    iconColor: theme.colorScheme.onPrimary,
                    onTap: () => _navigateToGenerateScreen(context, QRType.plainText),
                  ),
                  _QrCodeOptionCard(
                    icon: LucideIcons.wifi,
                    text: 'Create new\nWifi',
                    iconBackgroundColor: theme.colorScheme.surface,
                    iconColor: theme.colorScheme.onPrimary,
                    onTap: () => _navigateToGenerateScreen(context, QRType.wifi),
                  ),
                  _QrCodeOptionCard(
                    icon: LucideIcons.link,
                    text: 'Create new\nURL',
                    iconBackgroundColor: theme.colorScheme.surface,
                    iconColor: theme.colorScheme.onPrimary,
                    onTap: () => _navigateToGenerateScreen(context, QRType.url),
                  ),
                  _QrCodeOptionCard(
                    icon: LucideIcons.userRound,
                    text: 'Create new\nContact',
                    iconBackgroundColor: theme.colorScheme.surface,
                    iconColor: theme.colorScheme.onPrimary,
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
  final Color iconBackgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QrCodeOptionCard({
    required this.icon,
    required this.text,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.secondary,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Future.delayed(const Duration(milliseconds: 70), () {
            onTap();
          });
        },
        borderRadius: BorderRadius.circular(18),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        highlightColor: Colors.transparent,
        splashFactory: InkRipple.splashFactory,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 58.75 / 2,
                backgroundColor: iconBackgroundColor,
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
                  color: theme.colorScheme.onSecondary,
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
