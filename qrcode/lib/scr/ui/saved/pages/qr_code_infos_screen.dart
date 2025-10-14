import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';
import 'package:qrqrcode/scr/ui/widgets/custom_appBar_new.dart';
import 'package:qrqrcode/scr/ui/widgets/qr_action_buttons.dart';
import 'package:qrqrcode/scr/ui/widgets/qr_result_display.dart';
import 'package:screenshot/screenshot.dart';

class QRcodeInfos extends StatelessWidget {
  final ScanResult result;
  final ScreenshotController _screenshotController = ScreenshotController();

  QRcodeInfos({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBarNew(
        title: QRUtils.getTypeName(result.type),
        textColor: theme.colorScheme.onSecondary,
        backgroundColor: theme.colorScheme.background,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: theme.colorScheme.onSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Screenshot(
                controller: _screenshotController,
                child: Container(
                  color: theme.colorScheme.background,
                  padding: const EdgeInsets.all(12),
                  child: QrImageView(
                    data: result.rawValue,
                    size: 150,
                    version: QrVersions.auto,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.white,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.onSecondary,
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: QRUtils.getIconType(
                        result.type,
                        size: 25,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    QRUtils.getTypeName(result.type),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  QrResultDisplay(result: result),
                  const SizedBox(height: 16),
                  QRActionButtons(result: result),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
