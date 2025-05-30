import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrqrcode/utils/qr_utils.dart';
import '../../../models/scan_result.dart';
import '../../../widgets/qr_action_buttons.dart';

const bgColor = Color(0xfffafafa);

class ResultScreen extends StatelessWidget {
  final String urlexemplo = 'https://www.google.com/search?q=pesquisa';
  final ScanResult result;
  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Result QR Code',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_circle_left, color: Colors.black87),
        ),
      ),
      body: Column(
         
        children: [
          Container(
            
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/frame2.svg',
                      width: 240,
                      height: 240,
                    ),
                    QrImageView(
                      data: result.rawValue,
                      size: 180,
                      version: QrVersions.auto,
                    ),
                   
                  ],
                   
                ),
                 SizedBox(height: 10),
              ],
              
            ),
            
          ),
          const SizedBox(height: 40),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ícone aqui
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: QRUtils.getIconType(
                    result.type,
                    size: 34,
                    color: Color(0xffBBFB4C),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                QRUtils.getTypeName(result.type),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: 310,
                height: 53,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                   borderRadius: BorderRadius.circular(15),
              
              
                  border: Border.all(
                    color: Color(0xff2D2D2D),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    result.rawValue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1,
                      color: Color(0xffBCBDBC),
                  
                  ),
                ),
              ),
              ),
            ],
          ),

          const SizedBox(height: 20),

         QRActionButtons(
            result: result,
          ),
          
        ],
      ),
    );
  }
}
