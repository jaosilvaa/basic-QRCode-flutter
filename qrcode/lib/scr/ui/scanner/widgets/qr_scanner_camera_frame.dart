import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';

class QrScannerCameraFrame extends StatelessWidget {
  final double scannerSize;
  final double borderRadius;
  final MobileScannerController controller;
  final GestureScaleStartCallback onScaleStart;
  final GestureScaleUpdateCallback onScaleUpdate;
  final GestureScaleEndCallback onScaleEnd;

  const QrScannerCameraFrame({
    super.key,
    required this.scannerSize,
    required this.borderRadius,
    required this.controller,
    required this.onScaleStart,
    required this.onScaleUpdate,
    required this.onScaleEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        onScaleEnd: onScaleEnd,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/frame.svg',
              width: scannerSize * 1.18,
              height: scannerSize * 1.18,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: SizedBox(
                width: scannerSize * 0.9,
                height: scannerSize * 0.9,
                child: MobileScanner(controller: controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
