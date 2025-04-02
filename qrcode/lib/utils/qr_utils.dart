import '../models/qr_type.dart';

class QRUtils {
  static QRType detectType(String value) {
    value = value.trim();


    if (value.startsWith('http://') || value.startsWith('https://')) {
      return QRType.url;
    }
    
    
    if (value.startsWith('mailto:')) {
      return QRType.email;
    }
    
    
    if (value.startsWith('tel:')) {
      return QRType.phone;
    }
    
    
    if (value.startsWith('sms:')) {
      return QRType.sms;
    }
    
    
    if (value.startsWith('WIFI:') || value.startsWith('wifi:')) {
      return QRType.wifi;
    }
    
    
    if (value.startsWith('BEGIN:VCARD')) {
      return QRType.vcard;
    }

    
    return QRType.plainText;
  }

  static String getTypeName(QRType type) {
    switch (type) {
      case QRType.url: return 'URL';
      case QRType.email: return 'Email';
      case QRType.phone: return 'Phone';
      case QRType.sms: return 'SMS';
      case QRType.wifi: return 'WiFi';
      case QRType.vcard: return 'Contact';
      case QRType.plainText: return 'Text';
      default: return 'Unknown';
    }
  }
}