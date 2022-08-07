import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  bool lowApi = false;

  bool _connected = false;
  bool get connected => _connected;

  //stream allow to subscribe to connection changes
  StreamController<bool> connectivityStreamController = StreamController.broadcast();
  Stream<bool> get connectionChange => connectivityStreamController.stream;

  ConnectivityService() {
    init();
  }

  Future<void> init() async {
    Connectivity().onConnectivityChanged.listen(_checkConnection);
    await checkApiLevel;
  }

  Future<String> getDeviceID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      // ${androidInfo.device}
      return (await deviceInfo.androidInfo).androidId;
    } else if (Platform.isIOS) {
      return (await deviceInfo.iosInfo).identifierForVendor;
    }
    return null;
  }

  Future<void> get checkApiLevel async {
    //check API LEVEL
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final apiLEVEL = androidInfo.version.sdkInt;
      if (apiLEVEL < 20) lowApi = true;
    }
  }

  //process ConnectivityResult status and notify screens
  _checkConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      _connected = false;
      connectivityStreamController.sink.add(_connected);
      notifyListeners();
    } else if (!_connected) {
      _connected = await _connectionValid;
      connectivityStreamController.sink.add(_connected);
      notifyListeners();
    }

    //OLD approach used when need to preserve already loaded data while online
    // else if (_connected == false) {
    //   _connected = await _connectionValid;
    //   notifyListeners();
    // }
  }

  //The test to actually see if there is a connection
  Future<bool> get _connectionValid async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    connectivityStreamController.close();
    super.dispose();
  }
}
