import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finney/pages/1-auth/presentation/pin_entry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InactivityHandler extends StatefulWidget {
  final Widget child;
  const InactivityHandler({super.key, required this.child});

  @override
  State<InactivityHandler> createState() => _InactivityHandlerState();
}

class _InactivityHandlerState extends State<InactivityHandler> {
  Timer? _inactivityTimer;
  static const int _inactivityDuration = 30 * 60;

  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: _inactivityDuration), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final storage = FlutterSecureStorage();
      final storedPin = await storage.read(key: 'pin_${user.uid}');
      debugPrint('Inactivity check - Stored PIN: $storedPin');
      if (mounted && storedPin != null && storedPin.isNotEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PinEntryPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      onScaleStart: (_) => _resetInactivityTimer(),
      child: widget.child,
    );
  }
}