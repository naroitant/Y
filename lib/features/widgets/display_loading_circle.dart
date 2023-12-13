import 'package:flutter/material.dart';

void displayLoadingCircle(context) {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}