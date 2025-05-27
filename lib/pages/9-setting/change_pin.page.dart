import 'package:finney/pages/1-auth/widgets/my_textfield.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finney/pages/1-auth/presentation/login_page.dart';
import 'package:finney/pages/1-auth/widgets/my_button.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final _pinController = TextEditingController();
  bool _obscurePin = true;
  bool _isLoading = false;
  int _step = 0; // 0: current PIN, 1: new PIN, 2: confirm PIN
  String? _newPin;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handlePinInput() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage(onTap: null)),
      );
      return;
    }

    final input = _pinController.text.trim();
    debugPrint('Input: "$input", Length: ${input.length}, Step: $_step');
    if (input.length != 4 || !RegExp(r'^\d{4}$').hasMatch(input)) {
      debugPrint('Validation failed: Length=${input.length}, Regex=${RegExp(r'^\d{4}$').hasMatch(input)}');
      AppSnackBar.showError(
        context,
        message: LocaleData.pinInvalid.getString(context),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final storage = FlutterSecureStorage();
      if (_step == 0) {
        final storedPin = await storage.read(key: 'pin_${user.uid}');
        debugPrint('Stored PIN: $storedPin, Entered: $input');
        if (storedPin == null || storedPin != input) {
          AppSnackBar.showError(
            context,
            message: LocaleData.invalidPin.getString(context),
          );
          return;
        }
        setState(() {
          _step = 1;
          _pinController.clear();
        });
      } else if (_step == 1) {
        setState(() {
          _newPin = input;
          _step = 2;
          _pinController.clear();
        });
      } else {
        if (input != _newPin) {
          AppSnackBar.showError(
            context,
            message: LocaleData.pinsDontMatch.getString(context),
          );
          setState(() {
            _step = 1;
            _newPin = null;
            _pinController.clear();
          });
          return;
        }

        await storage.write(key: 'pin_${user.uid}', value: input);
        final savedPin = await storage.read(key: 'pin_${user.uid}');
        debugPrint('Saved PIN: $savedPin');
        AppSnackBar.showSuccess(
          context,
          message: LocaleData.changePin.getString(context),
        );
        Navigator.pop(context); // Return to Settings
      }
    } catch (e) {
      debugPrint('Error saving PIN: $e');
      AppSnackBar.showError(
        context,
        message: LocaleData.errorSavingData.getString(context),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          LocaleData.security.getString(context),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Icon(Icons.lock, size: 100, color: AppColors.darkBlue),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _step == 0
                        ? LocaleData.enterPin.getString(context)
                        : _step == 1
                            ? LocaleData.enterNewPin.getString(context)
                            : LocaleData.confirmNewPin.getString(context),
                    style: const TextStyle(
                      color: AppColors.darkBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: _pinController,
                  hintText: _step == 0
                      ? LocaleData.enterPin.getString(context)
                      : _step == 1
                          ? LocaleData.enterNewPin.getString(context)
                          : LocaleData.confirmPin.getString(context),
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
                _isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        text: LocaleData.submit.getString(context),
                        onTap: _handlePinInput,
                      ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}