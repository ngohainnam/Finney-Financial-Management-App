import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  final InternetConnectionChecker _connectionChecker = InternetConnectionChecker();
  bool _isConnected = false;
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  ConnectivityService() {
    _initConnectivity();
    _connectionChecker.onStatusChange.listen(_updateConnectionStatus);
  }

  bool get isConnected => _isConnected;
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  Future<void> _initConnectivity() async {
    try {
      final hasConnection = await _connectionChecker.hasConnection;
      _updateConnectionStatus(
        hasConnection 
          ? InternetConnectionStatus.connected 
          : InternetConnectionStatus.disconnected
      );
    } catch (e) {
      _isConnected = false;
      _connectionStatusController.add(false);
    }
  }

  void _updateConnectionStatus(InternetConnectionStatus status) {
    _isConnected = status == InternetConnectionStatus.connected;
    _connectionStatusController.add(_isConnected);
  }

  void dispose() {
    _connectionStatusController.close();
  }

  // Add this method for more detailed connection info if needed
  Future<bool> hasInternetAccess() async {
    return await _connectionChecker.hasConnection;
  }
}