import 'package:flutter/material.dart';
import 'package:langread/providers/VocabProviders.dart';
import 'package:langread/providers/SettingsProvider.dart';
import 'package:langread/providers/BookProvider.dart';
import 'package:langread/server/pocketbase.dart';
import 'package:langread/views/library_book_detail_view.dart';
import 'package:langread/views/book_store_view.dart';
import 'package:langread/views/login_screen.dart';
import 'package:langread/views/public_library_view.dart';
import 'package:langread/views/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/home_screen.dart';

import 'config/ThemeData.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  SharedPreferencesWithCache prefsWithCache = await initalizeSharedPreferences();
  // PocketBaseService();
  PocketBaseService().initialize(prefsWithCache);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VocabularyProvider()),
        ChangeNotifierProvider(
      create: (context) => SettingsProvider(prefsWithCache)),
      ChangeNotifierProvider(create: (context) => BookProvider()),
      ],
      child: MyApp()));
}
class MyApp extends StatelessWidget {
  PocketBaseService pbService = PocketBaseService();
  @override
  Widget build(BuildContext context) {
    return  
        MaterialApp(
          title: 'LangRead',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: Provider.of<SettingsProvider>(context, listen: false).themeMode,
          //home: HomeScreen(selectedIndex: 0,),
          initialRoute: '/login',
          routes: {
            '/login': (context) {
              if (pbService.isAuthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                });
                return Container(); // Return an empty container while navigating
              } else {
                return LoginScreen();
              }
            },
            '/signup': (context) {
              if (pbService.isAuthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                });
                return Container(); // Return an empty container while navigating
              } else {
                return SignupScreen();
              }
            },
            '/home': (context) => HomeScreen(selectedIndex: 0,),
            '/library': (context) => HomeScreen(selectedIndex: 0,),
            '/reading': (context) => HomeScreen(selectedIndex: 1,),
            '/vocabulary': (context) => HomeScreen(selectedIndex: 2,),
            '/settings': (context) => HomeScreen(selectedIndex: 3,),
            '/public-library': (context) => PublicLibraryScreen(),
            '/bookstore': (context) => BookStoreScreen(),
            '/book': (context) => LibraryBookDetailView(book: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['book']),
          },
        );
  }
}
    // final arguments = (arguments ?? <String, dynamic>{}) as Map;
