import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  double _fontSize = 20.0;
  ThemeMode _themeMode = ThemeMode.system;

  double get fontSize => _fontSize;
  double get subfontSize => _fontSize - 4;
  double get superfontSize => _fontSize + 4;

  ThemeMode get themeMode => _themeMode;

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}