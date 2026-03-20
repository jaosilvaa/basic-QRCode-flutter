import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/domain/models/enums/qr_style_type.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/shared/utils/context_extensions.dart'; 
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';
import 'package:qrqrcode/scr/ui/saved/controllers/saved_qr_controller.dart';
import 'package:qrqrcode/scr/ui/settings/controllers/qr_style_controller.dart';
import 'package:qrqrcode/scr/ui/widgets/custom_app_bar.dart';
import 'package:qrqrcode/scr/ui/widgets/qr_action_buttons.dart';
import 'package:qrqrcode/scr/ui/widgets/qr_result_display.dart';
import 'package:screenshot/screenshot.dart';

class QRcodeInfos extends StatefulWidget {
  final ScanResult result;

  const QRcodeInfos({
    super.key,
    required this.result,
  });

  @override
  State<QRcodeInfos> createState() => _QRcodeInfosState();
}

class _QRcodeInfosState extends State<QRcodeInfos> {
  final ScreenshotController _screenshotController = ScreenshotController();
  late ScanResult _localResult;

  bool _isFavorite = true;


  @override
  void initState() {
    super.initState();
    _localResult = widget.result;
  }

  void _toggleFavorite(BuildContext context) async{
    final savedController = context.read<SavedQrController>();

    setState(() {
      _isFavorite = !_isFavorite;
    });

    if(_isFavorite){
      await savedController.saveQrCode(_localResult);
      if(mounted){
        // ignore: use_build_context_synchronously
        context.showFeedback('Salvo nos Favoritos!', type: FeedbackType.success);
      }
    }else{
      await savedController.removeQrCode(_localResult.id);
      if(mounted){
        // ignore: use_build_context_synchronously
        context.showFeedback('Removido dos Favoritos.', type: FeedbackType.success);
      }
    }
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: _localResult.customName ?? '');
    final savedController = context.read<SavedQrController>();
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Editar Título'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    maxLength: 30,
                    autofocus: true,
                    onChanged: (value) {
                      if (errorMessage != null) {
                        setStateDialog(() {
                          errorMessage = null;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Ex: Wi-fi Sala',
                      errorText: errorMessage,
                      counterText: null, 
                    ),
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                      final color = currentLength == maxLength ? AppColors.error : AppColors.neutralBaseGrey;
                      return Text(
                        '$currentLength/$maxLength',
                        style: TextStyle(color: color, fontSize: 12),
                      );
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    final newName = controller.text.trim();
                    
                    if (newName.isEmpty) {
                      setStateDialog(() {
                        errorMessage = "O nome é obrigatório";
                      });
                      return;
                    }
                    await savedController.renameQrCode(_localResult.id, newName);
                    if (mounted) {
                      setState(() {
                        _localResult = _localResult.copyWith(customName: newName);
                      });
                    }

                    if (context.mounted) {
                      Navigator.pop(ctx);
                      context.showFeedback(
                        'Nome atualizado com sucesso!',
                        type: FeedbackType.success,
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final Color qrDataColor = isDark ? AppColors.white : AppColors.black;
    final Color iconColor = isDark ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        elevation: 0,
        title: _localResult.customName ?? QRUtils.getTypeName(_localResult.type),
        textColor: theme.colorScheme.onSecondary,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: theme.colorScheme.onSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => _showEditDialog(context),
            icon: Icon(Iconsax.edit, color: iconColor, size: 20,),
          ),
      
          IconButton(
            onPressed: () => _toggleFavorite(context),
            
            icon: Icon(
              _isFavorite ? Iconsax.heart5 : Iconsax.heart,
              color: _isFavorite ? AppColors.favoriteRed : AppColors.neutralBaseGrey,
          ),
          ),
          

          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Screenshot(
                controller: _screenshotController,
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                  padding: const EdgeInsets.all(12),
                  child: Consumer<QrStyleController>(
                    builder: (context, styleController, _) {
                      final isModern = styleController.qrStyle == QrStyleType.modern;
                      
                      return QrImageView(
                        data: _localResult.rawValue,
                        size: 150,
                        version: QrVersions.auto,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                        eyeStyle: QrEyeStyle(
                          eyeShape: isModern ? QrEyeShape.circle : QrEyeShape.square,
                          color: qrDataColor,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: isModern ? QrDataModuleShape.circle : QrDataModuleShape.square,
                          color: qrDataColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(31),
                  topRight: Radius.circular(31),
                ),
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outline, width: 1.0),
                  left: BorderSide(color: theme.colorScheme.outline, width: 1.0),
                  right: BorderSide(color: theme.colorScheme.outline, width: 1.0),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.onSecondary,
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: QRUtils.getIconType(
                            _localResult.type,
                            size: 25,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        QRUtils.getTypeName(_localResult.type),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      QrResultDisplay(result: _localResult),
                      const SizedBox(height: 20),
                      QRActionButtons(result: _localResult),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}