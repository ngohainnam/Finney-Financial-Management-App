import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog(
    {
      super.key,
      required this.message
    }
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)), // Rounded corners for the dialog
      ),
      backgroundColor: Colors.red[100], // Light red background for error message
      titlePadding: EdgeInsets.all(20),
      title: Text(
        'Error',
        style: TextStyle(
          color: Colors.red[800], // Darker red for the title
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      content: Text(
        message,
        style: TextStyle(
          color: Colors.red[700], // Darker red for the error message text
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              ),
          ),
        ),
      ],
    );
  }
}
