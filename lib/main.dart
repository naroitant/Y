import 'dart:async';
import 'dart:developer';
import 'firebase_options.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:y/configuration/environment/environment.dart';
import 'package:y/core/app.dart';
import 'package:y/core/di/app_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
}
