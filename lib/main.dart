import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_todo/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

final supportedLocales = [
  Locale('en', 'US'),
  Locale('ko', 'KR'),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  initializeDateFormatting().then(
    (_) => runApp(
      EasyLocalization(
        supportedLocales: supportedLocales,
        path: 'assets/locales',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: HomeScreen(),
    );
  }
}
