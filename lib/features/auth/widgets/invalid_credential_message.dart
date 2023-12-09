import 'package:flutter/material.dart';

void invalidCredentialMessage(String text, context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title:
          Center(
            child: Text(text),
          ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          )
        ],
      );
    }
  );
}