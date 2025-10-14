import 'package:flutter/material.dart';

class CustomAppBarNew extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? textColor;
  final IconThemeData? iconTheme;

  const CustomAppBarNew({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.iconTheme,
    this.backgroundColor, 
    this.textColor, 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    final baseTitleStyle = appBarTheme.titleTextStyle ??
        const TextStyle(fontSize: 40, fontWeight: FontWeight.w200);

    final resolvedTitleStyle = baseTitleStyle.copyWith(
      color: textColor ?? baseTitleStyle.color,
    );

    return AppBar(
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor ?? theme.colorScheme.background,
      elevation: 0,
      centerTitle: appBarTheme.centerTitle ?? true,
      iconTheme: iconTheme ??
          appBarTheme.iconTheme ??
          IconThemeData(color: textColor ?? appBarTheme.foregroundColor ?? theme.colorScheme.onBackground),
      title: Text(title, style: resolvedTitleStyle),
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}