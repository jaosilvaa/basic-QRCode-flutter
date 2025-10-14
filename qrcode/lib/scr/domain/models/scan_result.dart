import 'package:qrqrcode/scr/domain/models/qr_type.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';

class ScanResult {
  final String id;
  final String rawValue;
  final QRType type;
  final DateTime scanTime;

  ScanResult({
    required this.id,
    required this.rawValue,
    required this.type,
    DateTime? scanTime,
  }) : scanTime = scanTime ?? DateTime.now();

  factory ScanResult.fromRawValue(String value) {
    return ScanResult(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      rawValue: value,
      type: QRUtils.detectType(value),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rawValue': rawValue,
      'type': type.name,
      'scanTime': scanTime.toIso8601String(),
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      id: json['id'] as String,
      rawValue: json['rawValue'] as String,
      type: QRType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QRType.unknown,
      ),
      scanTime: DateTime.parse(json['scanTime'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanResult && other.rawValue == rawValue;
  }

  @override
  int get hashCode => rawValue.hashCode;
}