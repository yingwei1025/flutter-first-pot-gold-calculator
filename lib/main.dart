import 'package:firstpotm/home.dart';
import 'package:firstpotm/widget/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
        return MaterialApp(
          locale: provider.locale,
          debugShowCheckedModeBanner: false,
          title: 'First Pot God',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.all,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: const HomeScreen(),
        );
      }),
    );
  }
}
