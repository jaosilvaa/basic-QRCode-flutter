import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/ui/result/controllers/favorite_model.dart'; 

class FavoriteButton extends StatelessWidget {
  final ScanResult result;

  const FavoriteButton({
    super.key,
    required this.result,
  });

  void _showSnackBar(BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1400),
        backgroundColor: backgroundColor,
      ),
    );
  }

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
                  _showSnackBar(context, 'Removido dos favoritos.', theme.colorScheme.error);
                }
              } else {
                final wasSaved = await controller.addFavorite(result);
                if (context.mounted) {
                 _showSnackBar(
                  context,
                  wasSaved ? 'Salvo nos favoritos!' : 'Este QR Code já está salvo',
                  wasSaved ? AppColors.success : AppColors.warning,
                 );
                }
              }
            },
            borderRadius: BorderRadius.circular(55 / 2),
            splashColor: theme.colorScheme.onSurface.withOpacity(0.1 ),
            highlightColor: Colors.transparent,
            child: Ink(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xfff2f2f2),
                border: Border.all(
                  color: theme.colorScheme.onPrimary.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? AppColors.favoriteColor : theme.colorScheme.onPrimary.withOpacity(0.26),
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