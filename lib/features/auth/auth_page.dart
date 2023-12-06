import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:y/features/home/home_page.dart';
import 'package:y/features/auth/login_page.dart';

import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // The user is logged in.
          if (snapshot.hasData) {
            return HomePage();
          }

          // The user is not logged in.
          else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}