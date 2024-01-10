import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetProvider extends ChangeNotifier {
  bool isNet = false;

  ConnectivityResult connectivityResult = ConnectivityResult.none;

  NetProvider() {
    addNetListener();
  }

  void changeNetConnection(bool isNet) {
    this.isNet = isNet;
    notifyListeners();
  }

  void addNetListener() {
    Connectivity().onConnectivityChanged.listen((event) {
      connectivityResult = event;
      notifyListeners();
    });
  }
}
