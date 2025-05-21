import 'package:flutter/material.dart';
import 'package:finney/core/storage/storage_manager.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'dart:async';

class InternetConnectionHandler extends StatefulWidget {
  final Widget child;
  final Widget? offlineWidget;
  final Duration initialCheckDelay;
  
  const InternetConnectionHandler({
    super.key,
    required this.child,
    this.offlineWidget,
    this.initialCheckDelay = const Duration(seconds: 2),
  });

  @override
  State<InternetConnectionHandler> createState() => _InternetConnectionHandlerState();
}

class _InternetConnectionHandlerState extends State<InternetConnectionHandler> {
  bool _initialCheckComplete = false;
  late Timer _initialCheckTimer;
  
  @override
  void initState() {
    super.initState();
    // Set a timer to complete the initial check
    _initialCheckTimer = Timer(widget.initialCheckDelay, () {
      if (mounted) {
        setState(() {
          _initialCheckComplete = true;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _initialCheckTimer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: StorageManager().connectionStatus,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;
        
        // Always show main app during initial check
        if (!_initialCheckComplete) {
          return widget.child;
        }
        
        if (isConnected) {
          return widget.child;
        } else {
          // If we have a custom offline widget, use that
          if (widget.offlineWidget != null) {
            return widget.offlineWidget!;
          }
          
          // Default offline widget with proper directionality
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: AppColors.primary,
              fontFamily: 'NotoSerifBengali',
            ),
            home: _NoInternetScreen(),
          );
        }
      },
    );
  }
}

class _NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              size: 80.0,
              color: primaryColor,
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
                // This is just a visual indicator - actual connectivity checking
                // happens in the stream
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Checking connection...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
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