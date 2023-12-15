import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:y/features/settings/widgets/select_language_option.dart';
import 'package:y/features/settings/widgets/theme_switch.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool themeValue = true;

  changeTheme(bool newValue) {
    setState(() {
      themeValue = newValue;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    // Redirect to the login page.
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: ListView(
          children: [
            const SizedBox(height: 40),

            Row(
              children: [
                const Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),

                const SizedBox(width: 10),

                Text(
                  AppLocalizations.of(context)!.ui,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(
              height: 20,
              thickness: 1,
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.darkTheme,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ThemeSwitch(),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),

                const SizedBox(width: 10),

                Text(
                  AppLocalizations.of(context)!.account,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(
              height: 20,
              thickness: 1,
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(AppLocalizations.of(context)!.selectLanguage),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SelectLanguageOption(
                                languageCode: 'en', languageName: 'English'),

                            SizedBox(height: 10),

                            SelectLanguageOption(
                                languageCode: 'ru', languageName: 'русский'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context)!.close),
                          ),
                        ],
                      );
                    }
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.language,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                signUserOut();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.signOut,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}