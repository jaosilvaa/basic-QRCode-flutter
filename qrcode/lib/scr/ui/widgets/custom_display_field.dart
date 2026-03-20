import 'package:flutter/material.dart';

class CustomDisplayField extends StatelessWidget {
  final String label;
  final String value;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomDisplayField({
    super.key,
    required this.label,
    required this.value,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    // Cores dinâmicas
    final Color inputFillColor = theme.scaffoldBackgroundColor; 
    final Color inputBorderColor = theme.colorScheme.outline; 
    final Color inputTextColor = isDark ? Colors.white : Colors.black;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle( 
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: inputFillColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: inputBorderColor,
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  obscureText ? '••••••••' : value,
                  style: textTheme.bodyLarge?.copyWith(
                    color: inputTextColor, 
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffixIcon != null) suffixIcon!,
            ],
          ),
        ),
      ],
    );
  }
}