import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrqrcode/scr/domain/parser/qr_parser.dart';
import 'package:qrqrcode/scr/shared/utils/context_extensions.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart'; 

class WifiManager{
  static Future<bool> connectToWifi(
    BuildContext context,
    String qrData, {
    bool showFeedback = true,
    }) async {
      try{
        final  Map<String, String> wifiData = QRParser.parseWifi(qrData);
        final String? ssidRaw = wifiData['S'];
        if(ssidRaw == null || ssidRaw.isEmpty){
          if(showFeedback){
            context.showFeedback(
              'SSID inválido',
              type: FeedbackType.error,
            );
          }
          return false;
        }
        final String ssid = ssidRaw.trim();

        await Permission.location.request();
        
        final String? currentSsidRaw = await WiFiForIoTPlugin.getSSID();
        final String currentSsid = (currentSsidRaw ?? '').replaceAll('"', '').trim();
        if(currentSsid.isNotEmpty &&
          currentSsid != '<unknown ssid>' &&
          currentSsid.toLowerCase() == ssid.toLowerCase()){
            if(showFeedback){
              context.showFeedback(
                'Você já está conectado à rede $ssid',
                type: FeedbackType.warning,
              );
            }
            return true;
        }

        final String password = wifiData['P'] ?? '';
        final authType = wifiData['T'] ?? 'WPA';

        final NetworkSecurity security;
        switch (authType.toUpperCase()){
          case 'WEP':
            security = NetworkSecurity.WEP;
            break;
          case 'NONE':
          case 'NOPASS':
            security = NetworkSecurity.NONE;
            break;
          default:
            security = NetworkSecurity.WPA;
            break;
        }
        try{
          await WiFiForIoTPlugin
            .registerWifiNetwork(
              ssid,
              password: password,
              security: security,
            )
            .timeout(
              const Duration(seconds: 2),
              onTimeout: () => false
            );
        }catch(e){

        }

        await WiFiForIoTPlugin.connect(
          ssid,
          password: password,
          security: security,
          joinOnce: true,
          withInternet: true,
        );

        bool isConnected = false;
        for(var i = 0; i<2; i++){
          await Future.delayed(const Duration(seconds: 1));
          final String? checkedSsidRaw = await WiFiForIoTPlugin.getSSID();
          final String checkedSsid = 
            (checkedSsidRaw ?? '').replaceAll('"', '').trim();
          
          if(checkedSsid.toLowerCase() == ssid.toLowerCase()){
            isConnected = true;
            break;
          }
        }

        if(isConnected){
          if(showFeedback){
            context.showFeedback(
              'Conectado à rede $ssid',
              type: FeedbackType.success,
            );
          }

          try{
            await WiFiForIoTPlugin.forceWifiUsage(true);
          }catch(_){}
          return true;
        }else{
          if(showFeedback){
            context.showFeedback(
              'Verifique se o Wi-fi está ligado!',
              type: FeedbackType.error,
            );
          }
          return false;
        }
      }catch(e){
        if(showFeedback){
          context.showFeedback(
            'Erro: $e',
            type: FeedbackType.error,
          );
        }
      return false;
      }
    }
 }
    