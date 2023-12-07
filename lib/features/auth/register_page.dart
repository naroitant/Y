import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:y/services/auth_service.dart';
import 'package:y/features/auth/widgets/my_button.dart';
import 'package:y/features/auth/widgets/square_tile.dart';
import 'package:y/features/auth/widgets/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Sign-up method.
  void signUserUp() async {
    // Show the loading circle.
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Try signing up.
    if (passwordController.text == confirmPasswordController.text) {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Create a new document in CLoud Firestore.
      FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.email)
        .set({
        // Initial username.
          'username' : emailController.text.split('0')[0],
          'bio' : ''
        // Add any additional fields as needed.
      });

      // Pop the loading circle.
      Navigator.of(context, rootNavigator: true).pop(context);
    } else {
      Navigator.pop(context);
      // Show the error message.
      invalidCredentialMessage('The passwords do not match.');
    }
  }

  // Show the error to the user.
  void invalidCredentialMessage(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
            Center(
              child:
                Text(
                  text,
                ),
            ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            )
          ],
        );
      }
    );
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
            
                // Welcome message.
                Text(
                  'Let\'s get to know each other!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
            
                const SizedBox(height: 25),
            
                // Username text field.
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),
            
                // Password text field.
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // Password confirmation text field.
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 20),
            
                // Sign In.
                MyButton(
                  text: 'Sign Up',
                  onTap: signUserUp,
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

                // Google Sign-In button.
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
            
                // Sign Up.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Sign in now',
                        style: TextStyle(
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
}