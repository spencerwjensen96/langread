import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  double _fontSize = 26.0;
  double _lineHeight = 2;
  ThemeMode _themeMode = ThemeMode.system;

  double get fontSize => _fontSize;
  double get subfontSize => _fontSize - 4;
  double get superfontSize => _fontSize + 4;
  double get lineHeight => _lineHeight;

  ThemeMode get themeMode => _themeMode;

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void setLineHeight(double height) {
    _lineHeight = height;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}