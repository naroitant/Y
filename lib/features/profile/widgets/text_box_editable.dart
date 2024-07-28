import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:y/features/themes/theme_provider.dart';

class TextBoxEditable extends StatelessWidget {
  final dynamic controller;
  final String sectionName;
  const TextBoxEditable({
    super.key,
    required this.controller,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust the parameters according to the selected theme.
    final themeProvider = Provider.of<ThemeProvider>(context);
    late int shade;
    (themeProvider.themeMode == ThemeMode.dark)
        ? shade = 400
        : shade = 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section name.
        Text(
          sectionName,
          style: TextStyle(color: Colors.grey[shade]),
        ),
        // Text.
        TextField(
          decoration: const InputDecoration(
            filled: true,
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(),
          ),
          controller: controller,
          style: const TextStyle(fontSize: 16),
        ),
      ]
    );
  }
}
