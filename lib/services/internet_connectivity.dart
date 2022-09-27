import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../log/logger.dart';

class InternetConnectivity extends ChangeNotifier {
  static late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool status = true;

  InternetConnectivity._();

  factory InternetConnectivity() {
    var instance = InternetConnectivity._();
    instance._init();
    return instance;
  }

  Future<bool> _lookupByDomain(String domain) async {
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

  void _init() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.bluetooth:
          // TODO: Handle this case.
          break;
        case ConnectivityResult.wifi:
          status = true;
          break;
        case ConnectivityResult.ethernet:
          status = true;
          break;
        case ConnectivityResult.mobile:
          status = true;
          break;
        case ConnectivityResult.none:
          status = false;
          break;
      }
      notifyListeners();
    });
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}
