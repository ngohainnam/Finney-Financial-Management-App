import 'package:finney/pages/1-auth/widgets/my_textfield.dart';
import 'package:finney/pages/9-setting/sign_out.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finney/pages/1-auth/presentation/login_page.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/pages/1-auth/widgets/my_button.dart';

class PinEntryPage extends StatefulWidget {
  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  final _pinController = TextEditingController();
  bool _obscurePin = true;
  int _attempts = 0;
  final int _maxAttempts = 3;

  Future<void> _verifyPin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage(onTap: null)),
      );
      return;
    }

    final storage = FlutterSecureStorage();
    final storedPin = await storage.read(key: 'pin_${user.uid}');
    debugPrint('Stored PIN: $storedPin, Entered PIN: ${_pinController.text}');

    if (storedPin == null || storedPin.isEmpty) {
      AppSnackBar.showError(
        context,
        message: LocaleData.noPinSet.getString(context),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage(onTap: null)),
      );
      return;
    }

    if (_pinController.text == storedPin && _pinController.text.length == 4) {
      _pinController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Dashboard()),
      );
    } else {
      setState(() => _attempts++);
      _pinController.clear();
      if (_attempts == _maxAttempts) {
        AppSnackBar.showWarning(
          context,
          message: LocaleData.lastPinAttempt.getString(context),
        );
      } else if (_attempts > _maxAttempts) {
        await _handleMaxAttemptsExceeded();
      } else {
        AppSnackBar.showError(
          context,
          message: LocaleData.invalidPin.getString(context),
        );
      }
    }
  }

  Future<void> _handleMaxAttemptsExceeded() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage(onTap: null)),
      );
      return;
    }

    final storage = FlutterSecureStorage();
    await storage.delete(key: 'pin_${user.uid}');
    debugPrint('PIN deleted for user: ${user.uid}');
    await signOut(context); // Navigates to LanguageSelectionPage
  }

  Future<void> _handleForgotPin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage(onTap: null)),
      );
      return;
    }

    final storage = FlutterSecureStorage();
    await storage.delete(key: 'pin_${user.uid}');
    debugPrint('PIN deleted for user: ${user.uid}');
    AppSnackBar.showInfo(
      context,
      message: LocaleData.pinReset.getString(context),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage(onTap: null)),
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
                Icon(Icons.lock, size: 100, color: AppColors.darkBlue),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleData.enterPin.getString(context),
                      style: const TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _pinController,
                  hintText: LocaleData.enterPin.getString(context),
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePin ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePin = !_obscurePin),
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: LocaleData.submit.getString(context),
                  onTap: _verifyPin,
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: _handleForgotPin,
                  child: Text(
                    LocaleData.forgotPin.getString(context),
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.w500,
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