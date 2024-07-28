import 'package:flutter/material.dart';
import 'package:y/features/navigation/widgets/app_router_widget.dart';
import 'package:y/features/widgets/language_constants.dart';

class SelectLanguageOption extends StatelessWidget {
  final String languageCode;
  final String languageName;

  const SelectLanguageOption({
    super.key,
    required this.languageCode,
    required this.languageName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Locale locale = await setLocale(languageCode);
        AppRouterWidget.setLocale(context, locale);
        Navigator
            .of(context)
            .pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              languageName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
