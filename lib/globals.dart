import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'log/logger.dart';

class Globals {
  Globals._();

  static Future<ConnectivityResult> getConnectivityStatus() async =>
      await (Connectivity().checkConnectivity());

  static Future<bool> lookupInternet() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.debug('Internet connected');
      }
    } on SocketException catch (_) {
      Logger.error('Internet not connected');
      return false;
    }
    return true;
  }
}
