import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrqrcode/models/scan_result.dart';
import 'package:qrqrcode/screens/home/result_screen.dart';
import 'package:qrqrcode/widgets/qrcode_overlay.dart';

const bgColor = Color(0xfffafafa);

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with SingleTickerProviderStateMixin {
  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;
  late AnimationController _animationController;
  MobileScannerController controller = MobileScannerController();
  
  @override
  void initState() {
    super.initState();
    
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    
    _animationController.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void closeScreen() {
    setState(() {
      isScanCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: Drawer(),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            setState((){
              isFlashOn = !isFlashOn;
            });
            controller.toggleTorch();
          }, icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.grey)),

          IconButton(onPressed: (){
            setState((){
              isFrontCamera = !isFrontCamera;
            });
            controller.switchCamera();
          }, icon: Icon(Icons.switch_camera, color: Colors.grey)),
        ],
        centerTitle: true,
        title: const Text('QR Scanner'),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            // Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Text(
            //         'Place the QR code in the area',
            //         style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold
            //         ),
            //       ),
            //       const Text(
            //         'Scanning will start automatically',
            //         style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.normal
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: controller,
                    onDetect: (barcode) {
                      if (!isScanCompleted) {
                        String code = barcode.barcodes.first.rawValue ?? '---';
                        setState(() {
                          isScanCompleted = true;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              result: ScanResult.fromRawValue(code),
                              closeScreen: closeScreen,
                            ),
                          )
                        ).then((_) {
                          
                          setState(() {
                            isScanCompleted = false;
                          });
                        });
                      }
                    },
                  ),
                  
                  QRScannerOverlay(
                    overlayColour: bgColor,
                    animationController: _animationController,
                  ),
                  
                  // Textos posicionados sobre o scanner
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: const [
                        Text(
                          'Place the QR code in the area',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              backgroundColor: Color.fromRGBO(250, 250, 250, 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Scanning will start automatically',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                              backgroundColor: Color.fromRGBO(250, 250, 250, 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Developed by jaosilvaa',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}