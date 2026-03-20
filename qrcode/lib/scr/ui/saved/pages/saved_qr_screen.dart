import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/core/theme/app_colors.dart';
import 'package:qrqrcode/scr/ui/saved/controllers/saved_qr_controller.dart';
import 'package:qrqrcode/scr/ui/saved/widgets/saved_qr_card.dart';
import 'package:shimmer/shimmer.dart';

class SavedQrScreen extends StatefulWidget {
  const SavedQrScreen({super.key});

  @override
  State<SavedQrScreen> createState() => _SavedQrScreenState();
}

class _SavedQrScreenState extends State<SavedQrScreen> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    final controller = context.read<SavedQrController>();
    
    _initializationFuture = controller.prepareScreen();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.black : AppColors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.white : AppColors.black,
        ),
        title: Text(
          'Histórico',
          style: GoogleFonts.roboto(
            color: isDark ? AppColors.white : AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: FutureBuilder<void>(
        future: _initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          return Consumer<SavedQrController>(
            builder: (context, savedQrController, child) {

              if (savedQrController.isLoading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (savedQrController.isLoading) {
                    savedQrController.initialize();
                  }
                });

                return Shimmer.fromColors(
                  direction: ShimmerDirection.ltr,
                  baseColor: isDark 
                      ? AppColors.black 
                      : AppColors.white,
                  highlightColor: isDark 
                      ? AppColors.neutralGrey950 
                      : AppColors.neutralLightGrey,
                  child: ListView.builder(
                    itemCount: savedQrController.shimmerItemCount,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: SizedBox(
                          height: 70,
                          child: Card(
                            color: isDark 
                                ? AppColors.neutralGrey950 
                                : AppColors.neutralLightGrey,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (savedQrController.savedQrCode.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [ 
                      Image.asset(
                      isDark? 'assets/195.png': 'assets/197.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No QR Codes Saved Yet',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDark ? AppColors.white : AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                     )
                   ]
                  ),
                );
              }
              return ListView.builder(
                itemCount: savedQrController.savedQrCode.length,
                itemBuilder: (context, index) {
                  final scanResult = savedQrController.savedQrCode[index];
                  return SavedQrCard(scanResult: scanResult);
                },
              );
            },
          );
        },
      ),
    );
  }
}
