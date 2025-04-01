import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrqrcode/result_screen.dart';

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
    isScanCompleted = false;
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Place the QR code in the area',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const Text(
                    'Scanning will start automatically',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  // Scanner de QR
                  MobileScanner(
                    controller: controller,
                    onDetect: (barcode) {
                      if (!isScanCompleted) {
                        String code = barcode.barcodes.first.rawValue ?? '---';
                        isScanCompleted = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              code: code,
                              closeScreen: closeScreen,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  
                
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
              
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        children: [
                          // Canto superior esquerdo
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.green, width: 4),
                                  left: BorderSide(color: Colors.green, width: 4),
                                ),
                              ),
                            ),
                          ),
                          
                      
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.green, width: 4),
                                  right: BorderSide(color: Colors.green, width: 4),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.green, width: 4),
                                  left: BorderSide(color: Colors.green, width: 4),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.green, width: 4),
                                  right: BorderSide(color: Colors.green, width: 4),
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Positioned(
                                top: _animationController.value * 230,
                                
                                left: 10,
                                right: 10,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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