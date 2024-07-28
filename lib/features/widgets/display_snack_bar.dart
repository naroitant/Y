import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void displaySnackBar(String text, context) {
  final snackBar = SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: AppLocalizations
          .of(context)!
          .ok,
      onPressed: () {},
    ),
  );

  ScaffoldMessenger
      .of(context)
      .showSnackBar(snackBar);
}
