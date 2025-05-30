import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

enum NetworkSecurity { WPA, WEP, NONE }

const serializeNetworkSecurityMap = <NetworkSecurity, String>{
  NetworkSecurity.WPA: "WPA",
  NetworkSecurity.WEP: "WEP",
  NetworkSecurity.NONE: "NONE",
};

const MethodChannel _channel = const MethodChannel('wifi_iot');

class WiFiForIoTPlugin {
  /// Retorna se o WiFi está habilitado
  static Future<bool> isEnabled() async {
    final Map<String, String> htArguments = Map();
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('isEnabled', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult != null && bResult;
  }

  /// Habilita ou Desabilita o WiFi
  static setEnabled(bool state) async {
    final Map<String, bool> htArguments = Map();
    htArguments["state"] = state;
    try {
      await _channel.invokeMethod('setEnabled', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
  }

  /// Conecta a uma rede WiFi
  static Future<bool> connect(
    String ssid, {
    String? bssid,
    String? password,
    NetworkSecurity security = NetworkSecurity.NONE,
    bool joinOnce = false, // Alterado para false para salvar a rede
    bool withInternet = true,
    bool isHidden = false,
    int timeoutInSeconds = 30,
  }) async {
    if (ssid.length == 0 || ssid.length > 32) {
      print("SSID inválido");
      return false;
    }

    if (!Platform.isIOS && !await isEnabled()) await setEnabled(true);
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('connect', {
        "ssid": ssid.toString(),
        "bssid": bssid?.toString(),
        "password": password?.toString(),
        "join_once": joinOnce,
        "with_internet": withInternet,
        "is_hidden": isHidden,
        "timeout_in_seconds": timeoutInSeconds,
        "security": serializeNetworkSecurityMap[security],
      });
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult ?? false;
  }

  /// Registra uma rede WiFi no sistema
  static Future<bool> registerWifiNetwork(
    String ssid, {
    String? bssid,
    String? password,
    NetworkSecurity security = NetworkSecurity.NONE,
    bool isHidden = false,
  }) async {
    if (ssid.length == 0 || ssid.length > 32) {
      print("SSID inválido");
      return false;
    }

    if (!Platform.isIOS && !await isEnabled()) await setEnabled(true);
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('registerWifiNetwork', {
        "ssid": ssid.toString(),
        "bssid": bssid?.toString(),
        "password": password?.toString(),
        "security": serializeNetworkSecurityMap[security],
        "is_hidden": isHidden,
      });
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult ?? false;
  }

  /// Verifica se está conectado a uma rede WiFi
  static Future<bool> isConnected() async {
    final Map<String, String> htArguments = Map();
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('isConnected', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult ?? false;
  }

  /// Desconecta da rede atual
  static Future<bool> disconnect() async {
    final Map<String, bool> htArguments = Map();
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('disconnect', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult ?? false;
  }

  /// Obtém o SSID da rede atual
  static Future<String?> getSSID() async {
    final Map<String, String> htArguments = Map();
    String? sResult;
    try {
      sResult = await _channel.invokeMethod('getSSID', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return sResult;
  }

  /// Remove uma rede WiFi salva
  static Future<bool> removeWifiNetwork(String ssid) async {
    final Map<String, String> htArguments = Map();
    htArguments["ssid"] = ssid;
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('removeWifiNetwork', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult ?? false;
  }

  /// Verifica se uma rede está registrada
  static Future<bool> isRegisteredWifiNetwork(String ssid) async {
    final Map<String, String> htArguments = Map();
    htArguments["ssid"] = ssid;
    bool? bResult;
    try {
      bResult = await _channel.invokeMethod('isRegisteredWifiNetwork', htArguments);
    } on MissingPluginException catch (e) {
      print("MissingPluginException : ${e.toString()}");
    }
    return bResult ?? false;
  }
} 