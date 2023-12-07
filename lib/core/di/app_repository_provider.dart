import 'package:flutter/material.dart';

class AppRepositoriesProvider extends StatefulWidget {
  final Widget child;

  const AppRepositoriesProvider({
    required this.child,
    super.key,
  });

  @override
  State<AppRepositoriesProvider> createState() =>
      _AppRepositoriesProviderState();
}

class _AppRepositoriesProviderState extends State<AppRepositoriesProvider> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
