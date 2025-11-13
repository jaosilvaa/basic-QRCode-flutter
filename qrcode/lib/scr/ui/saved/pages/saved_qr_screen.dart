import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/ui/saved/controllers/saved_qr_controller.dart';
import 'package:qrqrcode/scr/ui/saved/widgets/saved_qr_card.dart';
import 'package:shimmer/shimmer.dart';

class SavedQrScreen extends StatefulWidget {
  const SavedQrScreen({super.key});

  @override
  State<SavedQrScreen> createState() => _SavedQrScreenState();
}

class _SavedQrScreenState extends State<SavedQrScreen> {

  @override
  void initState() {
    super.initState();
    
    final controller = context.read<SavedQrController>();
    controller.prepareScreen();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const Drawer(
       
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(
        color: Colors.white,
        ),
        title: const Text(
          'Histórico',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: Consumer<SavedQrController>(
        builder: (context, savedQrController, child) {

          if (savedQrController.isLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: const Color.fromARGB(255, 40, 40, 40),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: SizedBox(
                      height: 70,
                      child: Card(
                        color: Color(0xFF151515),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (savedQrController.savedQrCode.isEmpty) {
            return Center(
              child: Image.asset(
                'assets/195.png',
                height: 280,
                fit: BoxFit.contain,
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
      ),
    );
  }
}
