import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferencesWithCache> initalizeSharedPreferences() async {
   final SharedPreferencesWithCache prefsWithCache =
      await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{'themeMode', 'fontSize', 'lineHeight', 'pb_auth'},
    ),
  );
  // if (prefsWithCache.getString('themeMode') != null) {
  //   // print(prefsWithCache.getString('themeMode'));
  //   prefsWithCache.setString('themeMode', 'system');
  // }
  // if (prefsWithCache.getDouble('fontSize') != null) {
  //   // print('${prefsWithCache.getString('fontSize')}');
  //   prefsWithCache.setDouble('fontSize', 26.0);
  // }
  // if (prefsWithCache.getDouble('fontSize') != null) {
  //   // print(prefsWithCache.getString('lineHeight').toString());
  //   prefsWithCache.setDouble('lineHeight', 2.0);
  // }
  return prefsWithCache;
}

class SettingsProvider extends ChangeNotifier{
  late final prefs;

  SettingsProvider(SharedPreferencesWithCache prefsWithCache){
    prefs = prefsWithCache;
  }

  double get fontSize => prefs.getDouble('fontSize') ?? 26;
  double get subfontSize => prefs.getDouble('fontSize') - 4 ?? 22;
  double get superfontSize => prefs.getDouble('fontSize') ?? 30;
  double get lineHeight => prefs.getDouble('lineHeight') ?? 2;

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
    switch (mode.trim()){
      case 'system': return ThemeMode.system;
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }
}