import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void displayErrorMessage(String text, context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(text),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator
                    .of(context)
                    .pop();
              },
              child: Text(AppLocalizations
                  .of(context)!
                  .close),
            ),
          ],
        );
      }
  );
}
