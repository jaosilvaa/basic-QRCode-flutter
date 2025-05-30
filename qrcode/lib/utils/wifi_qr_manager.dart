import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';

class WifiQrParser {
  static Map<String, String> parse(String qrData) {
    if (!qrData.startsWith('WIFI:')) {
      throw FormatException('QR Code inválido: não começa com WIFI:');
    }

    final cleanData = qrData.substring(5);
    final regex = RegExp(r'(T|S|P|H):((?:.*?))(?=T:|S:|P:|H:|$)');
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
}

class WiFiManager {
  static Future<bool> _ensureWifiEnabled() async {
    bool isEnabled = await WiFiForIoTPlugin.isEnabled();
    if (!isEnabled) {
      return await WiFiForIoTPlugin.setEnabled(true);
    }
    return true;
  }

  static Future<bool> connectToWifi(
    BuildContext context,
    String qrData, {
    bool showFeedback = true,
  }) async {
    try {
      bool wifiEnabled = await _ensureWifiEnabled();
      if (!wifiEnabled) {
        if (showFeedback) _showSnackBar(context, 'Não foi possível ativar o Wi-Fi');
        return false;
      }

      Map<String, String> wifiInfo = WifiQrParser.parse(qrData);

      String? ssid = wifiInfo['S'];
      if (ssid == null || ssid.isEmpty) {
        if (showFeedback) _showSnackBar(context, 'SSID não encontrado');
        return false;
      }

      String? password = wifiInfo['P'] ?? '';
      String? securityType = wifiInfo['T'] ?? 'WPA';

      debugPrint('Tentando conectar a: $ssid (Tipo: $securityType)');

      NetworkSecurity security;
      switch (securityType.toUpperCase()) {
        case 'WEP':
          security = NetworkSecurity.WEP;
          break;
        case 'NONE':
        case 'NOPASS':
          security = NetworkSecurity.NONE;
          break;
        case 'WPA':
        case 'WPA2':
        default:
          security = NetworkSecurity.WPA;
          break;
      }
      bool registered = await WiFiForIoTPlugin.registerWifiNetwork(
        ssid,
        password: password,
        security: security,
      );

      if (!registered) {
        if (showFeedback) _showSnackBar(context, 'Falha ao registrar a rede $ssid');
        return false;
      }

      bool isConnected = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: security,
        joinOnce: false, 
        withInternet: true,
      );

      if (isConnected) {
        if (showFeedback) _showSnackBar(context, 'Conectado à rede $ssid');
        
        try {
          debugPrint('Forçando uso do WiFi para conexão de internet');
          await WiFiForIoTPlugin.forceWifiUsage(true);
        } catch (e) {
          debugPrint('Erro ao forçar uso do Wi-Fi: $e');
        }

        Timer(const Duration(seconds: 3), () async {
          bool isStillConnected = await WiFiForIoTPlugin.isConnected();
          String? currentSSID = await WiFiForIoTPlugin.getSSID();
          
          if (!isStillConnected || currentSSID != ssid) {
            if (showFeedback) _showSnackBar(context, 'Conexão instável. Tentando reconectar...');
            
            // Tenta reconectar
            isConnected = await WiFiForIoTPlugin.connect(
              ssid,
              password: password,
              security: security,
              joinOnce: false,
              withInternet: true,
            );
            
            if (isConnected && showFeedback) {
              _showSnackBar(context, 'Reconectado à rede $ssid');
            }
          } else if (showFeedback) {
            _showSnackBar(context, 'Conexão estável com $ssid');
          }
        });
        
        return true;
      } else {
        if (showFeedback) _showSnackBar(context, 'Falha ao conectar à rede $ssid');
        return false;
      }
    } catch (e) {
      debugPrint('Erro ao conectar ao Wi-Fi: $e');
      if (showFeedback) _showSnackBar(context, 'Erro ao conectar: ${e.toString()}');
      return false;
    }
  }
  static void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
