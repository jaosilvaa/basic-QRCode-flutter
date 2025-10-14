import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrqrcode/scr/core/theme/app_text_styles.dart';
import 'package:qrqrcode/scr/ui/result/widgets/favorite_button.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';
import 'package:qrqrcode/scr/ui/widgets/qr_result_display.dart';
import '../../../domain/models/scan_result.dart';
import '../../widgets/qr_action_buttons.dart';

const bgColor = Color(0xfffafafa);

class ResultScreen extends StatelessWidget {
  final ScanResult result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.onSecondary,
        centerTitle: true,
        title: Text(
          'Result QR Code',
          style: textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Iconsax.arrow_circle_left,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSecondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/frame2.svg',
                        width: 190,
                        height: 190,
                      ),
                      QrImageView(
                        data: result.rawValue,
                        size: 150,
                        version: QrVersions.auto,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FavoriteButton(result: result),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      QRUtils.getTypeName(result.type),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  QrResultDisplay(result: result),
                  const SizedBox(height: 16),
                  QRActionButtons(result: result),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
