import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';

class SecurityDialog extends StatefulWidget {
  final Function(String) onSavePin;

  const SecurityDialog({super.key, required this.onSavePin});

  @override
  State<SecurityDialog> createState() => _SecurityDialogState();
}

class _SecurityDialogState extends State<SecurityDialog> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _obscurePin = true;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleData.setPin.getString(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _pinController,
            decoration: InputDecoration(
              labelText: LocaleData.enterPin.getString(context),
              suffixIcon: IconButton(
                icon: Icon(_obscurePin ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePin = !_obscurePin),
              ),
            ),
            obscureText: _obscurePin,
            keyboardType: TextInputType.number,
            maxLength: 4,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          TextField(
            controller: _confirmPinController,
            decoration: InputDecoration(
              labelText: LocaleData.confirmPin.getString(context),
              suffixIcon: IconButton(
                icon: Icon(_obscurePin ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePin = !_obscurePin),
              ),
            ),
            obscureText: _obscurePin,
            keyboardType: TextInputType.number,
            maxLength: 4,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleData.cancel.getString(context)),
        ),
        TextButton(
          onPressed: () {
            if (_pinController.text != _confirmPinController.text) {
              AppSnackBar.showError(
                context,
                message: LocaleData.pinsDontMatch.getString(context),
              );
              return;
            }
            if (_pinController.text.length != 4) {
              AppSnackBar.showError(
                context,
                message: LocaleData.pinInvalid.getString(context),
              );
              return;
            }
            widget.onSavePin(_pinController.text);
            Navigator.pop(context);
          },
          child: Text(LocaleData.save.getString(context)),
        ),
      ],
    );
  }
}