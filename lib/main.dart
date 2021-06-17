import 'package:flutter/material.dart';
import 'package:pdf_reports_dark/pages/homePage.dart';
import 'package:pdf_reports_dark/pages/photoReportPage.dart';
import 'package:pdf_reports_dark/providers/th_provider.dart';
import 'package:pdf_reports_dark/providers/ui_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new UiProvider()),
        ChangeNotifierProvider(create: (_) => ThemeChanger(lightTheme))
      ],
      child: MaterialAppWhitTheme(),
    );
  }
}

class MaterialAppWhitTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'photo': (_) => PhotoReport(),
      },
      theme: theme.getTheme,
    );
  }
}
