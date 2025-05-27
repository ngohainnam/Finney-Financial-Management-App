import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  final InternetConnectionChecker _connectionChecker = InternetConnectionChecker();
  bool _isConnected = false;
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  ConnectivityService() {
    _initConnectivity();
    // Listen for changes in connectivity
    _connectionChecker.onStatusChange.listen((status) {
      _isConnected = status == InternetConnectionStatus.connected;
      _connectionStatusController.add(_isConnected);
    });
  }

  bool get isConnected => _isConnected;
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  Future<void> _initConnectivity() async {
    _isConnected = await _connectionChecker.hasConnection;
    _connectionStatusController.add(_isConnected);
  }

  Future<bool> checkConnectivity() async {
    _isConnected = await _connectionChecker.hasConnection;
    _connectionStatusController.add(_isConnected);
    return _isConnected;
  }

  void dispose() {
    _connectionStatusController.close();
  }
}