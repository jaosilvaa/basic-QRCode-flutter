import 'package:qrqrcode/scr/domain/models/qr_type.dart';

class QRParser {
  static Map<String, String> parseWifi(String qrData) {
    if (!qrData.startsWith('WIFI:')) {
      throw FormatException('QR Code inválido: não começa com WIFI:');
    }

    final cleanData = qrData.substring(5); 
    final regex = RegExp(r'(T|S|P|H):((?:.*?))(?=;T:|;S:|;P:|;H:|$)', caseSensitive: false);
    final matches = regex.allMatches(cleanData);

    final result = <String, String>{};

    for (final match in matches) {
      final key = match.group(1)!;
      String value = match.group(2)!;

      if (value.endsWith(';')) {
        value = value.substring(0, value.length - 1);
      }
      result[key] = value;
    }
    return result;
  }

  static String parserUrl(String qrData){
    return qrData.trim();
  }

  static String getSubtitle(QRType type, String rawValue){
    switch (type){
      case QRType.url:
        return parserUrl(rawValue);
      case QRType.wifi:
      try{
        final wifiInfo = parseWifi(rawValue);
        return wifiInfo['S'] ?? 'Rede Wi-Fi Desconhecida';
      } catch(e){
        return 'Erro ao analisar Wi-FI';
      }

      default:
        return rawValue;
    }
  }

}