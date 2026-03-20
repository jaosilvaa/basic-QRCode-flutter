import 'package:qrqrcode/scr/domain/models/enums/qr_type.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';

class ScanResult {
  final String id;
  final String rawValue;
  final QRType type;
  final DateTime scanTime;
  final String? customName;

  ScanResult({
    required this.id,
    required this.rawValue,
    required this.type,
    DateTime? scanTime,
    this.customName,
  }) : scanTime = scanTime ?? DateTime.now();

  ScanResult copyWith({
    String? id,
    String? rawValue,
    QRType? type,
    DateTime? scanTime,
    String? customName,
  }) {
    return ScanResult(
      id: id ?? this.id,
      rawValue: rawValue ?? this.rawValue,
      type: type ?? this.type,
      scanTime: scanTime ?? this.scanTime,
      customName: customName ?? this.customName,
    );
  }

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
      'customName': customName,
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
      customName: json['customName'] as String?,
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