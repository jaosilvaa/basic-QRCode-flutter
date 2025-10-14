import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SavedQrController>(context, listen: false).loadSavedQrCodes();
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
          if (!savedQrController.isLoading && savedQrController.savedQrCode.isEmpty) {
            return Center(
              child: Image.asset(
                'assets/195.png',
                height: 280,
                fit: BoxFit.contain,
              ),
            );
          }
          
          if (savedQrController.isLoading) {
            sleep(Durations.medium1);
            return Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: const Color.fromARGB(255, 29, 28, 28),
              child: ListView.builder(
                itemCount: savedQrController.savedQrCode.length == 0 ? 4 : savedQrController.savedQrCode.length,
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