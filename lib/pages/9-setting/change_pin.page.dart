import 'package:finney/pages/1-auth/login_or_register_page.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final List<String> _pinInput = [];
  final List<String> _newPinInput = [];
  final List<String> _confirmInput = [];
  bool _isLoading = false;
  int _step = 0; // 0: current PIN, 1: new PIN, 2: confirm PIN

  void _onKeyTap(String value) {
    if (_isLoading) return;
    setState(() {
      if (_step == 0) {
        if (_pinInput.length < 4) {
          _pinInput.add(value);
          if (_pinInput.length == 4) {
            _handlePinInput();
          }
        }
      } else if (_step == 1) {
        if (_newPinInput.length < 4) {
          _newPinInput.add(value);
          if (_newPinInput.length == 4) {
            setState(() {
              _step = 2;
            });
          }
        }
      } else if (_step == 2) {
        if (_confirmInput.length < 4) {
          _confirmInput.add(value);
          if (_confirmInput.length == 4) {
            _handlePinInput();
          }
        }
      }
    });
  }

  void _onDelete() {
    if (_isLoading) return;
    setState(() {
      if (_step == 0) {
        if (_pinInput.isNotEmpty) _pinInput.removeLast();
      } else if (_step == 1) {
        if (_newPinInput.isNotEmpty) _newPinInput.removeLast();
      } else if (_step == 2) {
        if (_confirmInput.isNotEmpty) _confirmInput.removeLast();
      }
    });
  }

  Widget _buildPinDots(List<String> input) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        bool filled = i < input.length;
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

  Future<void> _handlePinInput() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginOrRegisterPage()),
      );
      return;
    }

    final storage = FlutterSecureStorage();

    setState(() => _isLoading = true);

    try {
      if (_step == 0) {
        final enteredPin = _pinInput.join();
        final storedPin = await storage.read(key: 'pin_${user.uid}');
        if (storedPin == null || storedPin != enteredPin) {
          AppSnackBar.showError(
            context,
            message: LocaleData.pinsDoNotMatch.getString(context),
          );
          setState(() {
            _pinInput.clear();
          });
          return;
        }
        setState(() {
          _step = 1;
        });
      } else if (_step == 1) {
        // Wait for confirm step
      } else if (_step == 2) {
        final newPin = _newPinInput.join();
        final confirmPin = _confirmInput.join();

        if (newPin != confirmPin) {
          AppSnackBar.showError(
            context,
            message: LocaleData.pinsDoNotMatch.getString(context),
          );
          setState(() {
            _newPinInput.clear();
            _confirmInput.clear();
            _step = 1;
          });
          return;
        }
        if (newPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(newPin)) {
          AppSnackBar.showError(
            context,
            message: LocaleData.pinInvalid.getString(context),
          );
          setState(() {
            _newPinInput.clear();
            _confirmInput.clear();
            _step = 1;
          });
          return;
        }
        await storage.write(key: 'pin_${user.uid}', value: newPin);
        AppSnackBar.showSuccess(
          context,
          message: LocaleData.pinSaved.getString(context),
        );
        Navigator.pop(context); // Return to Settings
      }
    } catch (e) {
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
    String title;
    List<String> dots;
    if (_step == 0) {
      title = LocaleData.enterPin.getString(context);
      dots = _pinInput;
    } else if (_step == 1) {
      title = LocaleData.enterNewPin.getString(context);
      dots = _newPinInput;
    } else {
      title = LocaleData.confirmNewPin.getString(context);
      dots = _confirmInput;
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: Text(
          LocaleData.security.getString(context),
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(Icons.lock, size: 100, color: AppColors.darkBlue),
                const SizedBox(height: 25),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25),
                _buildPinDots(dots),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)
                    : _buildKeypad(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}