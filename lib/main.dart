import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/home_screen.dart';
import 'models/settings.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'LangRead',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
              fontSizeFactor: settings.fontSize / 16,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
              fontSizeFactor: settings.fontSize / 16,
            ),
          ),
          themeMode: settings.themeMode,
          home: HomeScreen(),
        );
      }
    );
  }
}