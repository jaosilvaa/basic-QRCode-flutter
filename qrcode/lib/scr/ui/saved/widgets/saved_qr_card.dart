import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/domain/parser/qr_parser.dart';
import 'package:qrqrcode/scr/shared/utils/context_extensions.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';
import 'package:qrqrcode/scr/ui/saved/controllers/saved_qr_controller.dart';
import 'package:qrqrcode/scr/ui/saved/pages/qr_code_details_screen.dart';


class SavedQrCard extends StatefulWidget{
  final ScanResult scanResult;


  const SavedQrCard({
    super.key,
    required this.scanResult,
  });


  @override
  State<SavedQrCard> createState() => _SavedQrCardState();


}


class _SavedQrCardState extends State<SavedQrCard> {


  @override
  Widget build(BuildContext context) {


    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final savedQrController = Provider.of<SavedQrController>(
      context,
      listen: false,
    );

    final String title = widget.scanResult.customName ??
                         QRUtils.getTypeNameSaveds(widget.scanResult.type);
                         
    final String subtitle = QRParser.getSubtitle(widget.scanResult.type, widget.scanResult.rawValue);
    final String formattedDate = DateFormat('HH:mm, MMM d').format(widget.scanResult.scanTime);
    final cardBackgroundColor = colorScheme.secondary;
    final iconContainerColor = colorScheme.tertiary;
    final iconAndTitleColor = theme.iconTheme.color ?? colorScheme.onSurface;
    final subtitleColor = AppColors.neutralDarkGrey;


    final Icon qrTypeIcon = QRUtils.getIconType(
      widget.scanResult.type,
      size: 24,
      color: iconAndTitleColor,
    );


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            Future.delayed(const Duration(milliseconds: 150), () {
              if(context.mounted){
                context.push(
                  '/saved/details/${widget.scanResult.id}',
                  extra: widget.scanResult,
                );
              }
            });
          },
          borderRadius: BorderRadius.circular(15),
          splashColor: isDark ? colorScheme.outline : colorScheme.tertiary,
          highlightColor: Colors.white.withValues(alpha: 0.15),
          child: Ink(
            decoration: BoxDecoration(
              color: cardBackgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: iconContainerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: qrTypeIcon),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: iconAndTitleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,          
                      child: InkResponse(
                         borderRadius: BorderRadius.circular(15),
                        onTap: () async {
                          context.showFeedback(
                            'Removido dos Favoritos.',
                            type: FeedbackType.success
                          );
                          await Future.delayed(const Duration(milliseconds: 300));
                          await savedQrController.removeQrCode(widget.scanResult.id);
                        },
                        customBorder: const CircleBorder(),
                        radius: 30,
                        splashColor: AppColors.favoriteRed.withValues(alpha: 0.4),
                        highlightColor: AppColors.favoriteRed.withValues(alpha: 0.15),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Iconsax.heart5,
                            color: AppColors.favoriteRed,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 10,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
