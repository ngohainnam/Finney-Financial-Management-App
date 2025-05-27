import 'package:finney/shared/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class SecurityDialog extends StatelessWidget {
  final Function(String) onSavePin;

  const SecurityDialog({
    super.key,
    required this.onSavePin,
  });

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    
    return AlertDialog(
      title: Text(LocaleData.setPin.getString(context)),
      content: TextField(
        controller: pinController,
        keyboardType: TextInputType.number,
        maxLength: 4,
        obscureText: true,
        decoration: InputDecoration(
          labelText: LocaleData.enterPin.getString(context),
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleData.cancel.getString(context)),
        ),
        TextButton(
          onPressed: () {
            if (pinController.text.length == 4) {
              onSavePin(pinController.text);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    LocaleData.invalidPin.getString(context),
                  ),
                ),
              );
            }
          },
          child: Text(LocaleData.save.getString(context)),
        ),
      ],
    );
  }
}