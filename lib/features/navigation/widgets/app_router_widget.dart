import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:y/configuration/navigation/app_router_configuration.dart';
import 'package:y/features/widgets/language_constants.dart';

class AppRouterWidget extends StatefulWidget {
  const AppRouterWidget({super.key});

  @override
  State<AppRouterWidget> createState() => _AppRouterWidgetState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _AppRouterWidgetState? state = context.findAncestorStateOfType<_AppRouterWidgetState>();
    state?.setLocale(newLocale);
  }
}

class _AppRouterWidgetState extends State<AppRouterWidget> {
  late GoRouter appRouter;
  Locale? _locale;

  @override
  void initState() {
    appRouter = AppRouterConfiguration.createRouter(context);
    super.initState();
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Y',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
    );
  }
}
