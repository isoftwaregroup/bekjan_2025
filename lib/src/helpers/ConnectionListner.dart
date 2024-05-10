import 'package:connectivity_plus/connectivity_plus.dart';

ConnectionListner? _connectionListner;

ConnectionListner get connectionListner {
  _connectionListner ??= ConnectionListner();
  return _connectionListner!;
}

class ConnectionListner {
  final checker = Connectivity();
  bool isOnline = false;
  bool isWifi = false;
  ConnectionChange socketConnectionListner = (isOnline) {};
  ConnectionChange homeConnectionListner = (isOnline) {};
  ConnectionListner() {
    checker.onConnectivityChanged.listen((result) {
      if (result.any((element) =>
          ConnectivityResult.ethernet == element ||
          ConnectivityResult.mobile == element)) {
        isOnline = true;
      } else if (result.any((element) => ConnectivityResult.wifi == element)) {
        isOnline = true;
        isWifi = true;
      } else {
        isOnline = false;
        isWifi = false;
      }
      socketConnectionListner(isOnline);
      homeConnectionListner(isOnline);
    });
  }
}

typedef void ConnectionChange(bool isOnline);
