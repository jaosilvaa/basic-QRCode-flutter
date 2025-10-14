import 'package:flutter/material.dart';

class CustomQRButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback onPressed;

  const CustomQRButton({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 1.5,
          ),
          // ignore: deprecated_member_use
          color: theme.colorScheme.outline.withOpacity(0.4),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onPressed,
          // ignore: sized_box_for_whitespace
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: iconColor ?? theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: textTheme.titleSmall,
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}