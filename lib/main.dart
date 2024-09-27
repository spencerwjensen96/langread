import 'package:flutter/material.dart';
import 'package:langread/providers/VocabProviders.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'views/home_screen.dart';
import 'models/settings.dart';
import 'config/ThemeData.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VocabularyProvider()),
        ChangeNotifierProvider(
      create: (context) => SettingsModel(),)
      ],
      child: Consumer<SettingsModel>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'LangRead',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          home: HomeScreen(selectedIndex: 0,),
          initialRoute: '/',
          routes: {
            '/home': (context) => HomeScreen(selectedIndex: 0,),
            '/library': (context) => HomeScreen(selectedIndex: 0,),
            '/reading': (context) => HomeScreen(selectedIndex: 1,),
            '/vocabulary': (context) => HomeScreen(selectedIndex: 2,),
            '/settings': (context) => HomeScreen(selectedIndex: 3,),
          },
        );
      }
    ),
    );
  }
}
