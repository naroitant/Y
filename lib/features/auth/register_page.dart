import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:y/features/auth/widgets/auth_service.dart';
import 'package:y/features/auth/widgets/my_button.dart';
import 'package:y/features/auth/widgets/my_text_field.dart';
import 'package:y/features/auth/widgets/square_tile.dart';
import 'package:y/features/widgets/display_error_message.dart';
import 'package:y/features/widgets/display_loading_circle.dart';
import 'package:y/features/themes/theme_provider.dart';

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

    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      // Pop the loading circle.
      Navigator.of(context, rootNavigator: true).pop(context);

      displayErrorMessage(
        AppLocalizations.of(context)!.oneOrMoreFieldsAreNotFilled,
        context,
      );
    } else
    // Try signing up.
    if (passwordController.text == confirmPasswordController.text) {
      // Check if the username contains alphabetic symbols only.
      if (alphabetic.hasMatch(usernameController.text)) {
        try {
          UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

          // Create a new document with user data in Cloud Firestore.
          FirebaseFirestore.instance
              .collection('Users')
              .doc(userCredential.user!.email)
              .set({
            'username': usernameController.text.split('0')[0],
            'bio': '',
            'imageUrl':
                'https://firebasestorage.googleapis.com/v0/b/y-app-afbd6.appspot.com/o/profile_pictures%2F1702467523950?alt=media&token=ac4698e3-594a-4424-8b4b-9fc961d9c750',
          });
        } on FirebaseAuthException catch (e) {
          // Pop the loading circle.
          Navigator.of(context, rootNavigator: true).pop(context);

          if (emailController.text == '' || passwordController.text == '') {
            displayErrorMessage(
              AppLocalizations.of(context)!.oneOrMoreFieldsAreNotFilled,
              context,
            );
          } else if (e.code == 'email-already-in-use') {
            displayErrorMessage(
              AppLocalizations.of(context)!.emailAlreadyInUse,
              context,
            );
          } else if (e.code == 'invalid-email') {
            displayErrorMessage(
              AppLocalizations.of(context)!.invalidEmail,
              context,
            );
          } else if (e.code == 'operation-not-allowed') {
            displayErrorMessage(
              AppLocalizations.of(context)!.operationNotAllowed,
              context,
            );
          } else if (e.code == 'weak-password') {
            displayErrorMessage(
              AppLocalizations.of(context)!.weakPassword,
              context,
            );
          }
        }
      } else {
        // Pop the loading circle.
        Navigator.of(context, rootNavigator: true).pop(context);

        displayErrorMessage(
          AppLocalizations.of(context)!
              .usernameMustIncludeAlphabeticSymbolsOnly,
          context,
        );
      }
    } else {
      // Pop the loading circle.
      Navigator.of(context, rootNavigator: true).pop(context);

      displayErrorMessage(
        AppLocalizations.of(context)!.passwordsDoNotMatch,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Adjust the parameters according to the selected theme.
    final themeProvider = Provider.of<ThemeProvider>(context);
    late int shade;
    late String pathToLogo;
    if (themeProvider.themeMode == ThemeMode.dark) {
      pathToLogo = 'lib/images/y_logo_light.png';
      shade = 400;
    } else {
      pathToLogo = 'lib/images/y_logo_dark.png';
      shade = 700;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Application logo.
                Image.asset(
                  pathToLogo,
                  height: 150,
                ),

                const SizedBox(height: 50),

                Text(
                  AppLocalizations.of(context)!.letUsGetToKnowEachOther,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                MyTextField(
                  controller: usernameController,
                  hintText: AppLocalizations.of(context)!.username,
                  obscureText: false,
                ),

                const SizedBox(height: 10),

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

                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: AppLocalizations.of(context)!.confirmPassword,
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                MyButton(
                  text: AppLocalizations.of(context)!.signUp,
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
                          color: Colors.grey[shade],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.orContinueWith,
                          style: TextStyle(
                            color: Colors.grey[shade],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[shade],
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
                      imagePath: 'lib/images/google_logo.png'),
                  ],
                ),

                const SizedBox(height: 10),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    AppLocalizations.of(context)!.alreadyHaveAnAccount,
                    style: TextStyle(
                      color: Colors.grey[shade],
                    )
                  ),

                  const SizedBox(width: 4),

                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      AppLocalizations.of(context)!.signInNow,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
