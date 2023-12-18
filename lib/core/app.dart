import 'package:flutter/material.dart';
import 'di/app_services.dart';

import 'package:y/core/di/app_providers.dart';
import 'package:y/features/navigation/app_router_widget.dart';

class MyApp extends StatelessWidget {
  final AppServices appServices;

  const MyApp({
    required this.appServices,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      appServices: appServices,
      child: const AppRouterWidget(),
    );
  }
}