import 'package:finney/pages/1-auth/widgets/my_textfield.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/pages/1-auth/widgets/my_button.dart';

class PinCreationPage extends StatefulWidget {
  const PinCreationPage({super.key});

  @override
  State<PinCreationPage> createState() => _PinCreationPageState();
}

class _PinCreationPageState extends State<PinCreationPage> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _obscurePin = true;

  Future<void> _savePin() async {
    debugPrint('Attempting to save PIN: ${_pinController.text}');
    if (_pinController.text != _confirmPinController.text) {
      AppSnackBar.showError(
        context,
        message: LocaleData.pinsDontMatch.getString(context),
      );
      return;
    }
    if (_pinController.text.length != 4 || !RegExp(r'^\d{4}$').hasMatch(_pinController.text)) {
      AppSnackBar.showError(
        context,
        message: LocaleData.pinInvalid.getString(context),
      );
      return;
    }
    final storage = FlutterSecureStorage();
    await storage.write(key: 'pin_${FirebaseAuth.instance.currentUser?.uid}', value: _pinController.text);
    final savedPin = await storage.read(key: 'pin_${FirebaseAuth.instance.currentUser?.uid}');
    debugPrint('Saved PIN: $savedPin');
    AppSnackBar.showSuccess(
      context,
      message: LocaleData.pinSaved.getString(context),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Dashboard()),
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
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleData.createPin.getString(context),
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
                const SizedBox(height: 10),
                MyTextField(
                  controller: _confirmPinController,
                  hintText: LocaleData.confirmPin.getString(context),
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
                  text: LocaleData.save.getString(context),
                  onTap: _savePin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}