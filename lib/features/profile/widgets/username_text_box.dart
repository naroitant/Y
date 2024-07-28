import 'package:flutter/material.dart';

class UsernameTextBox extends StatelessWidget {
  final dynamic controller;

  const UsernameTextBox({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 90, right: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
            ),
            controller: controller,
            style: const TextStyle(
              fontSize: 18,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.wavy,
            ),
            textAlign: TextAlign.center,
          ),
        ]
      ),
    );
  }
}