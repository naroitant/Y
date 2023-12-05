import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:y/core/di/app_services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:y/features/auth/auth_page.dart';

import 'firebase_options.dart';
import 'configuration/environment/environment.dart';
import 'core/app.dart';

/*void main() async {

  final appServices = AppServices(
    dio: Dio(Environment.baseDioOptions),
  );

  runZonedGuarded(
        () => runApp(
      MyApp(
        appServices: appServices,
      ),
    ),
        (error, stack) {
      log('$error', stackTrace: stack);
    },
  );
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}