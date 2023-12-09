import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:y/features/auth/widgets/invalid_credential_message.dart';

import 'package:y/services/auth_service.dart';
import 'package:y/features/auth/widgets/my_button.dart';
import 'package:y/features/auth/widgets/square_tile.dart';
import 'package:y/features/auth/widgets/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    // Show the loading circle.
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

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
        Navigator.of(context, rootNavigator: true).pop(context);
        invalidCredentialMessage('One or more fields are not filled.', context);
      }
      if (e.code == 'invalid-credential') {
        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);
        invalidCredentialMessage('Invalid email or password.', context);
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
                Image.asset('lib/images/y_logo_black.png', height: 150,),
            
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
                  hintText: 'Email',
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 4),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 10),

                MyButton(
                  text: 'Sign In',
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
                          'or continue with',
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
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
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
      welcomeMessage = "y tho?";
    } else if (randomInt == 2) {
      welcomeMessage = "уъу";
    } else {
      welcomeMessage = "Welcome back!";
    }

    return welcomeMessage;
  }
}