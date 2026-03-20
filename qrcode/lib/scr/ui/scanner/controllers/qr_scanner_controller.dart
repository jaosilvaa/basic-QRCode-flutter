import 'package:flutter/foundation.dart'; 
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerController {
  final MobileScannerController mobileController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
    torchEnabled: false,
    autoStart: false,
  );

  static const double minZoom = 0.6;
  double currentZoom = minZoom;
  double initialZoom = minZoom;

  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFrontCamera = false;

  Future<void> startCamera() async {
    if (mobileController.value.isInitialized &&
        mobileController.value.isRunning) return;
    await mobileController.start();
    await setZoom(minZoom);
  }

  Future<void> stopCamera() async {
    await mobileController.stop();
  }

  void onScaleStart() {
    initialZoom = currentZoom;
  }

  Future<void> onScaleUpdate(double scale) async {
    final candidateZoom = initialZoom + (scale - 1.0);
    if ((candidateZoom - currentZoom).abs() < 0.01) return;
    await setZoom(candidateZoom);
  }

  Future<void> setZoom(double zoom) async {
    if (kIsWeb) return; 

    currentZoom = zoom.clamp(minZoom, 1.0);
    if (!mobileController.value.isRunning) return;
    await mobileController.setZoomScale(currentZoom);
  }

  Future<void> resetZoom() => setZoom(minZoom);

  Future<void> toggleTorch() async {
    if (isFrontCamera) return;
    await mobileController.toggleTorch();
    isFlashOn = !isFlashOn;
  }

  Future<void> switchCamera() async {
    isFrontCamera = !isFrontCamera;
    isFlashOn = false;
    await mobileController.switchCamera();
  }

  void dispose() {
    mobileController.dispose();
  }
}