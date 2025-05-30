import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../models/qr_type.dart';

class QRUtils {
  static QRType detectType(String value) {
    value = value.trim();

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return QRType.url;
    }
     
    if (value.startsWith('MATMSG:')) {
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

  static Icon getIconType(QRType type, {double size = 18, Color color = const Color(0xffBBFB4C)}) {
    switch (type) {
      case QRType.url:
        return Icon(Iconsax.link, size: size, color: color);
      case QRType.email:
        return Icon(Iconsax.sms, size: size, color: color); 
      case QRType.phone:
        return Icon(Iconsax.call, size: size, color: color); 
      case QRType.sms:
        return Icon(Iconsax.sms, size: size, color: color); 
      case QRType.wifi:
        return Icon(Iconsax.wifi, size: size, color: color);
      case QRType.vcard:
        return Icon(Iconsax.user, size: size, color: color); 
      case QRType.plainText:
        return Icon(Iconsax.document, size: size, color: color); 
      default:
        return Icon(Iconsax.warning_2, size: size, color: color); 
    }
  }

  static String getTypeName(QRType type) {
    switch (type) {
      case QRType.url: return 'New link scanned';
      case QRType.email: return 'New Email scanned';
      case QRType.phone: return 'Phone';
      case QRType.sms: return 'SMS';
      case QRType.wifi: return 'New wifi scanned';
      case QRType.vcard: return 'Contact';
      case QRType.plainText: return 'Text';
      default: return 'Unknown';
    }
  }
}