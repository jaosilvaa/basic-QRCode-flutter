import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/shared/utils/context_extensions.dart';
  import 'package:qrqrcode/scr/ui/result/controllers/favorite_model.dart'; 

  class FavoriteButton extends StatelessWidget {
    final ScanResult result;

    const FavoriteButton({
      super.key,
      required this.result,
    });


    @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);

      return Consumer<FavoritesController>(
        builder: (context, controller, child) {
          final bool isFavorited = controller.isFavorite(result);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                if (isFavorited) {
                  
                  final existingFavorite = controller.findFavoriteByRawValue(result.rawValue);
                  if (existingFavorite != null) {
                    controller.removeFavorite(existingFavorite.id);
                  }
                  if(context.mounted) {

                    context.showFeedback(
                      'Removido dos favoritos.',
                      type: FeedbackType.success,
                    );
                  }
                } else {
                  final wasSaved = await controller.addFavorite(result);
                  if (context.mounted) {

                    context.showFeedback(
                      wasSaved ? 'Salvo nos favoritos!' : 'Este QR Code já está salvo',
                      type: wasSaved ? FeedbackType.success : FeedbackType.warning,
                    );
                  }
                }
              },
              borderRadius: BorderRadius.circular(55 / 2),
              splashColor: theme.colorScheme.onSurface.withValues(alpha: 0.1 ),
              highlightColor: Colors.transparent,
              child: Ink(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xfff2f2f2),
                  border: Border.all(
                    color: theme.colorScheme.onPrimary.withValues(alpha: .3),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? AppColors.favoriteRed : AppColors.neutralBaseGrey,
                    size: 24,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }