import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/scanner')) return 0;
    if (location.startsWith('/create')) return 1;
    if (location.startsWith('/saved')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/scanner'); break;
      case 1: context.go('/create'); break;
      case 2: context.go('/saved'); break;
      case 3: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomNavBackgroundColor = theme.bottomNavigationBarTheme.backgroundColor ?? Colors.black;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: theme.colorScheme.outline, width: 1)),
          color: bottomNavBackgroundColor,
        ),
        child: CustomBottomNavBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (index) => _onItemTapped(index, context),
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, 0, Iconsax.scan, 'Scanner'),
          _buildNavItem(context, 1, Iconsax.add_circle, 'Create'),
          _buildNavItem(context, 2, Iconsax.clock, 'Salvos'),
          _buildNavItem(context, 3, Iconsax.setting, 'Config'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = index == currentIndex;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    final selectedColor = isLight ? theme.colorScheme.onSurface : theme.colorScheme.primary;
    final selectedTextColor = theme.colorScheme.onSurface;
    final unselectedColor = theme.colorScheme.outline;

    return InkWell(
      onTap: () => onTap(index),
      splashColor: const Color(0xFFBBFB4C).withOpacity(0.2),
      highlightColor: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? selectedColor : unselectedColor, size: 26),
          if (isSelected) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: selectedTextColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }
}