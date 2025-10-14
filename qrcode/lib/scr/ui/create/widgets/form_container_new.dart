import 'package:flutter/material.dart';

class FormContainerNew extends StatelessWidget {
  final List<Widget> children;

  const FormContainerNew({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          
          decoration:  BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}


