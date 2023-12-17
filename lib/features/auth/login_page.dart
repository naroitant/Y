import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:y/features/auth/widgets/auth_service.dart';
import 'package:y/features/auth/widgets/my_button.dart';
import 'package:y/features/auth/widgets/my_text_field.dart';
import 'package:y/features/auth/widgets/square_tile.dart';
import 'package:y/features/widgets/display_error_message.dart';
import 'package:y/features/widgets/display_loading_circle.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    displayLoadingCircle(context);

    // Try signing in.
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Pop the loading circle.
      Navigator.of(context, rootNavigator: true).pop(context);
    } on FirebaseAuthException catch (e) {
      if (emailController.text == '' || passwordController.text == '') {
        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);

        displayErrorMessage(
          AppLocalizations.of(context)!.oneOrMoreFieldsAreNotFilled,
          context,
        );
      }
      if (e.code == 'invalid-credential') {
        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);

        displayErrorMessage(
          AppLocalizations.of(context)!.invalidEmailOrPassword,
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
            
                // Application logo.
                Image.asset(
                  'lib/images/y_logo_black.png',
                  height: 150,
                ),
            
                const SizedBox(height: 50),

                Text(
                  generateWelcomeMessage(),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
            
                const SizedBox(height: 25),

                MyTextField(
                  controller: emailController,
                  hintText: AppLocalizations.of(context)!.email,
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.password,
                  obscureText: true,
                ),
            
                const SizedBox(height: 4),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.forgotYourPassword,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 10),

                MyButton(
                  text: AppLocalizations.of(context)!.signIn,
                  onTap: signUserIn,
                ),
            
                const SizedBox(height: 10),
            
                // Suggest 3rd party authentication.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.orContinueWith,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google_logo.png'
                    ),
                  ],
                ),
            
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.notAMember,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        AppLocalizations.of(context)!.registerNow,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateWelcomeMessage() {
    int randomInt = Random().nextInt(5);
    String welcomeMessage;

    if (randomInt == 1) {
      welcomeMessage = AppLocalizations.of(context)!.yTho;
    } else {
      welcomeMessage = AppLocalizations.of(context)!.welcomeBack;
    }

    return welcomeMessage;
  }
}