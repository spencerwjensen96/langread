import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferencesWithCache> initalizeSharedPreferences() async {
   final SharedPreferencesWithCache prefsWithCache =
      await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{'themeMode', 'fontSize', 'lineHeight'},
    ),
  );
  prefsWithCache.setString('themeMode', 'system');
  prefsWithCache.setDouble('fontSize', 26.0);
  prefsWithCache.setDouble('lineHeight', 2.0);
  return prefsWithCache;
}

class SettingsProvider extends ChangeNotifier{
  late final prefs;

  SettingsProvider(SharedPreferencesWithCache prefsWithCache){
    prefs = prefsWithCache;
  }

  double get fontSize => prefs.getDouble('fontSize');
  double get subfontSize => prefs.getDouble('fontSize') - 4;
  double get superfontSize => prefs.getDouble('fontSize') + 4;
  double get lineHeight => prefs.getDouble('lineHeight');

  ThemeMode get themeMode => getMode(prefs.getString('themeMode'));

  void setFontSize(double size) async {
    // _fontSize = size;
    await prefs.setDouble('fontSize', size);
    notifyListeners();
  }

  void setLineHeight(double height) async {
    // _lineHeight = height;
    await prefs.setDouble('lineHeight', height);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    // _themeMode = mode;
    await prefs.setString('themeMode', mode.toString().split('.').last);
    notifyListeners();
  }

  static ThemeMode getMode(String mode){
    switch (mode){
      case 'system': return ThemeMode.system;
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }
}