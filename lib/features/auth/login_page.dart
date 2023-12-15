import 'dart:math';

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
      // Pop the loading circle.
      Navigator.of(context, rootNavigator: true).pop(context);

      if (emailController.text == '' || passwordController.text == '') {
        displayErrorMessage(
          AppLocalizations.of(context)!.oneOrMoreFieldsAreNotFilled,
          context,
        );
      } else if (e.code == 'invalid-credential') {
        displayErrorMessage(
          AppLocalizations.of(context)!.invalidEmailOrPassword,
          context,
        );
      } else if (e.code == 'invalid-email') {
        displayErrorMessage(
          AppLocalizations.of(context)!.invalidEmail,
          context,
        );
      } else if (e.code == 'user-disabled') {
        displayErrorMessage(
          AppLocalizations.of(context)!.userDisabled,
          context,
        );
      } else if (e.code == 'user-not-found') {
        displayErrorMessage(
          AppLocalizations.of(context)!.userNotFound,
          context,
        );
      } else if (e.code == 'wrong-password') {
        displayErrorMessage(
          AppLocalizations.of(context)!.wrongPassword,
          context,
        );
      }
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
                  generateWelcomeMessage(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[shade],
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
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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
                      imagePath: 'lib/images/google_logo.png',
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.notAMember,
                      style: TextStyle(
                        color: Colors.grey[shade],
                      ),
                    ),

                    const SizedBox(width: 4),

                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        AppLocalizations.of(context)!.registerNow,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
