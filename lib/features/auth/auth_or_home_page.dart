import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:y/features/home/home_page.dart';
import 'package:y/features/auth/login_or_register_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in.
          if (snapshot.hasData) {
            return const HomePage();
          }
          // User is not logged in.
          else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}