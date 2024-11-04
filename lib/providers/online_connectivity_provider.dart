// ignore: depend_on_referenced_packages
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';

class ConnectivityService with ChangeNotifier {
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityService() {
    Connectivity().onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile)) {
        _isOnline = true;
        debugPrint('online');
      } else if (result.contains(ConnectivityResult.wifi)) {
        _isOnline = true;
        debugPrint('online');
      } else {
        _isOnline = false;
        debugPrint('offline');
      }
      notifyListeners();
    });
  }
}
