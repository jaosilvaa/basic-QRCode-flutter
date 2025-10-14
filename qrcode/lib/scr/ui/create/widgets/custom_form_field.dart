import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart'; 

class CustomFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            filled: true,
            fillColor: theme.colorScheme.background,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.outline, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
            ),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return '$label não pode ficar vazio.';
                }
                return null;
              },
        ),
      ],
    );
  }
}
