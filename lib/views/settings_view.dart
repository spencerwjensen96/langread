import 'package:flutter/material.dart';


class SettingsView extends StatelessWidget {

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings View'),
      ),
    );
  }
}