import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:y/features/auth/widgets/my_button.dart';
import 'package:y/features/auth/widgets/my_text_field.dart';
import 'package:y/features/auth/widgets/square_tile.dart';
import 'package:y/features/widgets/display_error_message.dart';
import 'package:y/features/widgets/display_loading_circle.dart';
import 'package:y/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final alphabetic = RegExp(r'^[a-zA-Z]+$');

  void signUserUp() async {
    displayLoadingCircle(context);

    if (usernameController.text == '' || emailController.text == '' ||
        passwordController.text == '' || confirmPasswordController.text == '') {
      // Pop the loading circle.
      Navigator.of(context, rootNavigator: true).pop(context);

      displayErrorMessage('One or more fields are not filled.', context);
    }

    // Try signing up.
    if (passwordController.text == confirmPasswordController.text) {
      // Check if the username contains alphabetic symbols only.
      if (alphabetic.hasMatch(usernameController.text)) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Create a new document with user data in Cloud Firestore.
        FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            'username' : usernameController.text.split('0')[0],
            'bio' : '',
            'imageUrl' : 'https://firebasestorage.googleapis.com/v0/b/y-app-afbd6.appspot.com/o/profile_pictures%2F1702467523950?alt=media&token=ac4698e3-594a-4424-8b4b-9fc961d9c750',
          });

        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);
      } else {
        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);

        displayErrorMessage('Username must include alphabetic symbols only.', context);
      }
    } else {
      // Pop the loading circle.
      Navigator.of(context, rootNavigator: true).pop(context);

      displayErrorMessage('Passwords do not match.', context);
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
                  'Let\'s get to know each other!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

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

                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 20),

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