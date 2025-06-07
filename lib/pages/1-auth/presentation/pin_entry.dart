import 'package:finney/pages/1-auth/login_or_register_page.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/pages/0-onboarding/onboarding_intro.dart';

class PinEntryPage extends StatefulWidget {
  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  final List<String> _input = [];
  bool _isVerifying = false;

  Future<void> _verifyPin() async {
    if (_isVerifying) return;
    setState(() => _isVerifying = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginOrRegisterPage()),
      );
      return;
    }

    final storage = FlutterSecureStorage();
    final storedPin = await storage.read(key: 'pin_${user.uid}');
    debugPrint('Stored PIN: $storedPin, Entered PIN: ${_input.join()}');

    if (storedPin == null || storedPin.isEmpty) {
      AppSnackBar.showError(
        context,
        message: LocaleData.noPinSet.getString(context),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginOrRegisterPage()),
      );
      return;
    }

    if (_input.join() == storedPin && _input.length == 4) {
      AppSnackBar.showSuccess(
        context,
        message: LocaleData.pinVerified.getString(context),
      );
      setState(() {
        _input.clear();
        _isVerifying = false;
      });

      // Check onboarding status in Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final onboarding = userDoc.data()?['onboarding'];

      if (onboarding == null || onboarding.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OnboardingIntroPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Dashboard()),
        );
      }
    } else {
      AppSnackBar.showError(
        context,
        message: LocaleData.pinsDoNotMatch.getString(context),
      );
      setState(() {
        _input.clear();
        _isVerifying = false;
      });
    }
  }

  Future<void> _handleForgotPin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginOrRegisterPage()),
      );
      return;
    }

    final storage = FlutterSecureStorage();
    await storage.delete(key: 'pin_${user.uid}');
    AppSnackBar.showInfo(
      context,
      message: LocaleData.pinReset.getString(context),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginOrRegisterPage()),
    );
  }

  void _onKeyTap(String value) {
    if (_isVerifying) return;
    if (_input.length < 4) {
      setState(() {
        _input.add(value);
      });
      if (_input.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onDelete() {
    if (_isVerifying) return;
    if (_input.isNotEmpty) {
      setState(() {
        _input.removeLast();
      });
    }
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        bool filled = i < _input.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: filled ? AppColors.darkBlue : Colors.transparent,
            border: Border.all(
              color: AppColors.darkBlue,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildKeypadButton(String label, {VoidCallback? onTap, IconData? icon, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: icon != null
            ? Icon(icon, color: color ?? AppColors.darkBlue, size: 30)
            : Text(
                label,
                style: TextStyle(
                  fontSize: 28,
                  color: color ?? AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton('1', onTap: () => _onKeyTap('1')),
            const SizedBox(width: 24),
            _buildKeypadButton('2', onTap: () => _onKeyTap('2')),
            const SizedBox(width: 24),
            _buildKeypadButton('3', onTap: () => _onKeyTap('3')),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton('4', onTap: () => _onKeyTap('4')),
            const SizedBox(width: 24),
            _buildKeypadButton('5', onTap: () => _onKeyTap('5')),
            const SizedBox(width: 24),
            _buildKeypadButton('6', onTap: () => _onKeyTap('6')),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton('7', onTap: () => _onKeyTap('7')),
            const SizedBox(width: 24),
            _buildKeypadButton('8', onTap: () => _onKeyTap('8')),
            const SizedBox(width: 24),
            _buildKeypadButton('9', onTap: () => _onKeyTap('9')),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 70),
            const SizedBox(width: 24),
            _buildKeypadButton('0', onTap: () => _onKeyTap('0')),
            const SizedBox(width: 24),
            _buildKeypadButton(
              '',
              onTap: _onDelete,
              icon: Icons.backspace_outlined,
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(Icons.lock, size: 100, color: AppColors.primary),
                const SizedBox(height: 25),
                Text(
                  LocaleData.enterPin.getString(context),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 25),
                _buildPinDots(),
                const SizedBox(height: 40),
                _buildKeypad(),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _handleForgotPin,
                  child: Text(
                    LocaleData.forgotPin.getString(context),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}