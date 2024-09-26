import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer<SettingsModel>(
        builder: (context, settings, child) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              const Text(
                'Font Size',
              ),
              Slider(
                value: settings.fontSize,
                min: 10,
                max: 30,
                divisions: 10,
                label: settings.fontSize.round().toString(),
                onChanged: (value) {
                  settings.setFontSize(value);
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Font Height',
              ),
              Slider(
                value: settings.lineHeight,
                min: 1.0,
                max: 2.5,
                divisions: 15,
                label: settings.lineHeight.toString(),
                onChanged: (value) {
                  settings.setLineHeight(value);
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Theme',
              ),
              RadioListTile<ThemeMode>(
                title: Text('System'),
                value: ThemeMode.system,
                groupValue: settings.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) settings.setThemeMode(value);
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text('Light'),
                value: ThemeMode.light,
                groupValue: settings.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) settings.setThemeMode(value);
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text('Dark'),
                value: ThemeMode.dark,
                groupValue: settings.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) settings.setThemeMode(value);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
