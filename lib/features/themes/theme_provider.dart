import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    (themeMode == isOn)
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors
        .grey
        .shade900,
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
    iconTheme: const IconThemeData(
      color: Colors.white,
      opacity: 0.8,
    )
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[200],
    primaryColor: Colors.grey[900],
    colorScheme: const ColorScheme.light(),
    iconTheme: const IconThemeData(
      color: Colors.black,
      opacity: 0.8,
    ),
  );
}