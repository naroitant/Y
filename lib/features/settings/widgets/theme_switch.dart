import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:y/features/themes/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      activeColor: Colors.blue[500],
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}