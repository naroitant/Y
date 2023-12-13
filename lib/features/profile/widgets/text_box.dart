import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final controller;
  final String sectionName;
  const TextBox({
    super.key,
    required this.controller,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section name.
        Text(
          sectionName,
          style: TextStyle(color: Colors.grey[700]),
        ),
        // Text.
        TextField(
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(),
          ),
          controller: controller,
          style: const TextStyle(fontSize: 16),
          readOnly: true,
        ),
      ]
    );
  }
}