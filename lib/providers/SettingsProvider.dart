import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier{
  late final prefs;

  SettingsProvider(SharedPreferencesWithCache prefsWithCache){
    prefs = prefsWithCache;
  }

  double get fontSize => prefs.getDouble('fontSize') ?? 26;
  double get subfontSize => prefs.getDouble('fontSize') ?? 22;
  double get superfontSize => prefs.getDouble('fontSize') ?? 30;
  double get lineHeight => prefs.getDouble('lineHeight') ?? 2;

  ThemeMode get themeMode => getMode(prefs.getString('themeMode'));

  void setFontSize(double size) async {
    await prefs.setDouble('fontSize', size);
    notifyListeners();
  }

  void setLineHeight(double height) async {
    await prefs.setDouble('lineHeight', height);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    await prefs.setString('themeMode', mode.toString().split('.').last);
    notifyListeners();
  }

  static ThemeMode getMode(String? mode){
    if(mode == null) return ThemeMode.system;
    switch (mode.trim()){
      case 'system': return ThemeMode.system;
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }
}