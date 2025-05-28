import 'package:flutter/material.dart';
import 'package:finney/core/storage/storage_manager.dart';

class InternetConnectionHandler extends StatelessWidget {
  final Widget child;
  final Widget? offlineWidget;
  
  const InternetConnectionHandler({
    super.key,
    required this.child,
    this.offlineWidget,
  });
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: StorageManager().connectionStatus,
      initialData: StorageManager().isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        
        if (isConnected) {
          return child;
        } else {
          return offlineWidget ?? _buildDefaultOfflineWidget(context);
        }
      },
    );
  }
  
  Widget _buildDefaultOfflineWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24.0),
            const Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Please check your internet connection and try again.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Checking connection...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}