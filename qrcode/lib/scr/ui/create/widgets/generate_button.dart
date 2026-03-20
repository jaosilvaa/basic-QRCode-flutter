import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/core/theme/app_text_styles.dart';

class GenerateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GenerateButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Texto sempre BRANCO em ambos os modos
    final textColor = isDark? AppColors.white : AppColors.black;
    
    // Modo Dark: fundo Grey 950, borda Grey 900
    // Modo Light: fundo Light Grey, borda Base Grey
    final backgroundColor = isDark ? AppColors.neutralGrey950 : AppColors.neutralLightGrey;
    final borderColor = isDark ? AppColors.neutralGrey900 : AppColors.neutralBaseGrey;

    return SizedBox(
      width: 295,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: borderColor,
              width: 1.5,
            ),
          ),
          elevation: 0,
        ),
        child: Text(
          'Generate',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: AppTextStyles.semiBold, 
            color: textColor,
          ),
        ),
      ),
    );
  }
}
