import 'package:flutter/material.dart';
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
    return SizedBox(
      width: 295,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF18191B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFF2D2D2D), width: 1.5),
          ),
          elevation: 0,
        ),
        child:  Text(
          'Generate',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: AppTextStyles.semiBold, 
            color: theme.colorScheme.onSecondary
          ),
            
          ),
        ),

    );
  }
}