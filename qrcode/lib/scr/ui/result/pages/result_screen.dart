import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/core/theme/app_text_styles.dart';
import 'package:qrqrcode/scr/domain/models/enums/qr_style_type.dart';
import 'package:qrqrcode/scr/ui/result/widgets/favorite_button.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';
import 'package:qrqrcode/scr/ui/settings/controllers/qr_style_controller.dart';
import 'package:qrqrcode/scr/ui/widgets/custom_app_bar.dart';
import 'package:qrqrcode/scr/ui/widgets/qr_result_display.dart';
import '../../../domain/models/scan_result.dart';
import '../../widgets/qr_action_buttons.dart';

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
    final isDark = theme.brightness == Brightness.dark;
    final topBackgroundColor = isDark ? AppColors.white : AppColors.neutralLightGrey;
    final modalBackgroundColor = isDark ? AppColors.black : AppColors.white;

    return Scaffold(
      backgroundColor: modalBackgroundColor,
      appBar: CustomAppBar(
        title: 'Result QR Code',
        backgroundColor: topBackgroundColor,
        textColor: AppColors.black,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
        ),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: topBackgroundColor,
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
                      Consumer<QrStyleController>(
                        builder: (context, styleController, _){
                          final isModern = styleController.qrStyle == QrStyleType.modern;
                          final eyeShape = isModern ? QrEyeShape.circle : QrEyeShape.square;
                          final dataShape = isModern ? QrDataModuleShape.circle  : QrDataModuleShape.square;

                          return QrImageView(
                            data: result.rawValue,
                            size: 150,
                            version: QrVersions.auto,
                            eyeStyle: QrEyeStyle(
                              eyeShape: eyeShape,
                              color: AppColors.black,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: dataShape,
                              color: AppColors.black,
                            ),
                          );
                        },
                      )
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
                        color: isDark ? AppColors.white : AppColors.black,
                        width: 1.2,
                      ),
                    ),
                    child: Center(
                      child: QRUtils.getIconType(
                        result.type,
                        size: 25,
                        color: isDark? theme.colorScheme.primary : AppColors.black
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      QRUtils.getTypeName(result.type),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: isDark ? AppColors.white : AppColors.black,
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
