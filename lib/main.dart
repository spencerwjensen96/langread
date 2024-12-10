import 'package:flutter/material.dart';
import 'package:bookbinding/config/SharedPreferences.dart';
import 'package:bookbinding/providers/DictionaryProvider.dart';
import 'package:bookbinding/providers/VocabProviders.dart';
import 'package:bookbinding/providers/SettingsProvider.dart';
import 'package:bookbinding/providers/BookProvider.dart';
import 'package:bookbinding/server/pocketbase.dart';
import 'package:bookbinding/views/library_book_detail_view.dart';
import 'package:bookbinding/views/book_store_view.dart';
import 'package:bookbinding/views/login_screen.dart';
import 'package:bookbinding/views/public_library_view.dart';
import 'package:bookbinding/views/reset_password.dart';
import 'package:bookbinding/views/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/home_screen.dart';

import 'config/ThemeData.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  SharedPreferencesWithCache prefsWithCache = await SharedPreferencesConfig.initalizeSharedPreferences();
  PocketBaseService().initialize(prefsWithCache);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VocabularyProvider()),
        ChangeNotifierProvider(
      create: (context) => SettingsProvider(prefsWithCache)),
        ChangeNotifierProvider(create: (context) => BookProvider(prefsWithCache)),
        Provider(create: (context) => DictionaryProvider()),
      ],
      child: MyApp()));
}
class MyApp extends StatelessWidget {
  final PocketBaseService pbService = PocketBaseService();

  MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return  
        MaterialApp(
          title: 'BookBinding',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: context.watch<SettingsProvider>().themeMode,
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
            '/reset-password': (context) => ResetPasswordScreen(),
            '/reset-password-sent': (context) => const ResetPasswordSentScreen(),
            '/home': (context) => HomeScreen(selectedIndex: 0,),
            '/library': (context) => HomeScreen(selectedIndex: 0,),
            '/reading': (context) => HomeScreen(selectedIndex: 1,),
            '/vocabulary': (context) => HomeScreen(selectedIndex: 2,),
            '/settings': (context) => HomeScreen(selectedIndex: 3,),
            '/public-library': (context) => PublicLibraryScreen(),
            '/bookstore': (context) => const BookStoreScreen(),
            '/book': (context) => LibraryBookDetailView(book: (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['book']),
            '/': (context) => HomeScreen(selectedIndex: 0,),
            
          },
        );
  }
}
