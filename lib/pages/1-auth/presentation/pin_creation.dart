import 'package:finney/shared/theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';

class PinCreationPage extends StatefulWidget {
  const PinCreationPage({super.key});

  @override
  State<PinCreationPage> createState() => _PinCreationPageState();
}

class _PinCreationPageState extends State<PinCreationPage> {
  final List<String> _pinInput = [];
  final List<String> _confirmInput = [];
  bool _isConfirming = false;
  bool _isSaving = false;

  Future<void> _savePin() async {
    setState(() => _isSaving = true);
    final pin = _pinInput.join();
    final confirmPin = _confirmInput.join();

    if (pin != confirmPin) {
      AppSnackBar.showError(
        context,
        message: LocaleData.pinsDontMatch.getString(context),
      );
      setState(() {
        _pinInput.clear();
        _confirmInput.clear();
        _isConfirming = false;
        _isSaving = false;
      });
      return;
    }
    if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
      AppSnackBar.showError(
        context,
        message: LocaleData.pinInvalid.getString(context),
      );
      setState(() {
        _pinInput.clear();
        _confirmInput.clear();
        _isConfirming = false;
        _isSaving = false;
      });
      return;
    }
    final storage = FlutterSecureStorage();
    await storage.write(key: 'pin_${FirebaseAuth.instance.currentUser?.uid}', value: pin);
    AppSnackBar.showSuccess(
      context,
      message: LocaleData.pinSaved.getString(context),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Dashboard()),
    );
  }

  void _onKeyTap(String value) {
    if (_isSaving) return;
    setState(() {
      if (!_isConfirming) {
        if (_pinInput.length < 4) {
          _pinInput.add(value);
          if (_pinInput.length == 4) {
            _isConfirming = true;
          }
        }
      } else {
        if (_confirmInput.length < 4) {
          _confirmInput.add(value);
          if (_confirmInput.length == 4) {
            _savePin();
          }
        }
      }
    });
  }

  void _onDelete() {
    if (_isSaving) return;
    setState(() {
      if (!_isConfirming) {
        if (_pinInput.isNotEmpty) _pinInput.removeLast();
      } else {
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

  @override
  Widget build(BuildContext context) {
    final isFirst = !_isConfirming;
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
                  isFirst
                      ? LocaleData.createPin.getString(context)
                      : LocaleData.confirmPin.getString(context),
                  style: const TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25),
                _buildPinDots(isFirst ? _pinInput : _confirmInput),
                const SizedBox(height: 40),
                _buildKeypad(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}