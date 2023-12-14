import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:y/features/navigation/widgets/app_router_widget.dart';
import 'package:y/features/widgets/language.dart';
import 'package:y/features/widgets/language_constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: DropdownButton<Language>(
                alignment: AlignmentDirectional.centerStart,
                icon: const Icon(
                  Icons.language,
                  color: Colors.black,
                ),
                hint: Text(AppLocalizations.of(context)!.changeLanguage),
                onChanged: (Language? language) async {
                  if (language != null) {
                    Locale locale = await setLocale(language.languageCode);
                    AppRouterWidget.setLocale(context, locale);
                  }
                },
                items: Language.languageList().map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                  value: e,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(e.name),
                    ],
                  ),
                )).toList(),
              ),
            ),
            IconButton(
              onPressed: signUserOut,
              icon: const Icon(Icons.logout),
              color: Colors.black,
            ),
          ]
        ),
      ),
    );
  }
}