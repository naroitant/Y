import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String languageCode = 'languageCode';
const String english = 'en';
const String russian = 'ru';

Future<Locale> setLocale(String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(languageCode, code);
  return locale(code);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String code = prefs.getString(languageCode) ?? english;
  return locale(code);
}

Locale locale(String code) {
  switch (code) {
    case english:
      return const Locale(english, '');
    case russian:
      return const Locale(russian, '');
    default:
      return const Locale(english, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}
