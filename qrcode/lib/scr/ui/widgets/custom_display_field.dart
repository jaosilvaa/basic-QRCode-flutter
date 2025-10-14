// scr/ui/result/widgets/custom_display_field.dart
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
          // ---- CORREÇÃO DEFINITIVA ----
          // 1. Usamos uma altura fixa para garantir que todos os campos sejam idênticos.
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF2D2D2D),
              width: 1.5,
            ),
          ),
          child: Row(
            // 2. Centralizamos verticalmente os filhos (texto e ícone) dentro da altura fixa.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  obscureText ? '••••••••' : value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
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