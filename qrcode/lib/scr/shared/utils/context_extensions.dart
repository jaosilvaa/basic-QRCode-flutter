import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';

enum FeedbackType { success, warning, error }

extension FeedbackExtension on BuildContext {
  void showFeedback(String message, {FeedbackType type = FeedbackType.success}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();

    final Color backgroundColor;
    switch (type) {
      case FeedbackType.success:
        backgroundColor = AppColors.success;
        break;
      case FeedbackType.warning:
        backgroundColor = AppColors.warning;
        break;
      case FeedbackType.error:
        backgroundColor = AppColors.error;
        break;
    }

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(milliseconds: 2500),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
