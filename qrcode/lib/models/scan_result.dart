import 'package:qrqrcode/models/qr_type.dart';
import 'package:qrqrcode/utils/qr_utils.dart';

class ScanResult {
  final String rawValue;
  final QRType type;
  final DateTime scanTime;

  ScanResult({
    required this.rawValue,
    required this.type,
    DateTime? scanTime,
  }) : scanTime = scanTime ?? DateTime.now();

  factory ScanResult.fromRawValue(String value){
    return ScanResult(
      rawValue: value,
      type: QRUtils.detectType(value),
      
    );
  }

}