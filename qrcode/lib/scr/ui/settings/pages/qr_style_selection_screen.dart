import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/domain/models/enums/qr_style_type.dart';
import 'package:qrqrcode/scr/ui/settings/controllers/qr_style_controller.dart';

class QrStyleSelectionScreen extends StatelessWidget {
  const QrStyleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Consumer<QrStyleController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black, 
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Select Style',
              style: theme.appBarTheme.titleTextStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildStyleOption(
                  context: context,
                  title: 'Rounded',
                  styleType: QrStyleType.modern,
                  currentStyle: controller.qrStyle,
                  onChanged: (val) {
                    if(val != null) controller.updateQrStyle(val);
                  },
                ),
                const SizedBox(height: 10),
                _buildStyleOption(
                  context: context,
                  title: 'Square', 
                  styleType: QrStyleType.traditional,
                  currentStyle: controller.qrStyle,
                  onChanged: (val) {
                     if(val != null) controller.updateQrStyle(val);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStyleOption({
    required BuildContext context,
    required String title,
    required QrStyleType styleType,
    required QrStyleType currentStyle,
    required ValueChanged<QrStyleType?> onChanged,
  }) {
    final theme = Theme.of(context);
    
    return RadioListTile<QrStyleType>(
      value: styleType,
      // ignore: deprecated_member_use
      groupValue: currentStyle,
      // ignore: deprecated_member_use
      onChanged: onChanged,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      activeColor: theme.colorScheme.primary, 
      tileColor: theme.colorScheme.surface,   
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}