import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/domain/parser/qr_parser.dart';
import 'package:wifi_iot/wifi_iot.dart';


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
        // ignore: use_build_context_synchronously
        if (showFeedback) _showSnackBar(context, 'Não foi possível ativar o Wi-Fi');
        return false;
      }

      Map<String, String> wifiInfo = QRParser.parseWifi(qrData);

      String? ssid = wifiInfo['S'];
      if (ssid == null || ssid.isEmpty) {
        // ignore: use_build_context_synchronously
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
        // ignore: use_build_context_synchronously
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
        // ignore: use_build_context_synchronously
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
            // ignore: use_build_context_synchronously
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
              // ignore: use_build_context_synchronously
              _showSnackBar(context, 'Reconectado à rede $ssid');
            }
          } else if (showFeedback) {
            // ignore: use_build_context_synchronously
            _showSnackBar(context, 'Conexão estável com $ssid');
          }
        });
        
        return true;
      } else {
        // ignore: use_build_context_synchronously
        if (showFeedback) _showSnackBar(context, 'Falha ao conectar à rede $ssid');
        return false;
      }
    } catch (e) {
      debugPrint('Erro ao conectar ao Wi-Fi: $e');
      // ignore: use_build_context_synchronously
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
