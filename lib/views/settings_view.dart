import 'package:flutter/material.dart';
import 'package:langread/server/pocketbase.dart';
import 'package:provider/provider.dart';
import '../providers/SettingsProvider.dart';

class SettingsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _pbService = PocketBaseService();
  final _usernameController = TextEditingController();
  bool _showAccountSettings = false;

  late Widget _usernameField;

  @override
  void initState() {
    super.initState();
    _usernameField = OutlinedButton(
                      onPressed: () {
                        _animateToNewWidget();
                      },
                      child: Text('Change Username'),
                    );
  }


  void _animateToNewWidget(){
    setState(() {
      _usernameField = Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              _usernameField = OutlinedButton(
                                onPressed: () {
                                  _animateToNewWidget();
                                },
                                child: Text('Change Username'),
                              );
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'New Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement username change
                          },
                          child: Text('Change Username'),
                        ),
                      ],
                    );
    });
  }

  void _toggleShowAccountSettings() {
    setState(() {
      _showAccountSettings = !_showAccountSettings;
    });
  }

  Widget _buildSettingSection(String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              _buildSettingSection(
                'Reading Settings',
                [
                  ListTile(
                    title: Text('Font Size'),
                    subtitle: Slider(
                      value: settings.fontSize,
                      min: 10,
                      max: 30,
                      divisions: 10,
                      label: settings.fontSize.round().toString(),
                      onChanged: (value) {
                        settings.setFontSize(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Line Height'),
                    subtitle: Slider(
                      value: settings.lineHeight,
                      min: 1.0,
                      max: 2.5,
                      divisions: 15,
                      label: settings.lineHeight.toStringAsFixed(2),
                      onChanged: (value) {
                        settings.setLineHeight(value);
                      },
                    ),
                  ),
                ],
              ),
              _buildSettingSection(
                'Appearance',
                [
                  ListTile(
                    title: Text('Theme'),
                    trailing: DropdownButton<ThemeMode>(
                      value: settings.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) settings.setThemeMode(value);
                      },
                      items: [
                        DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                        DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                        DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                      ],
                    ),
                  ),
                ],
              ),
              _buildSettingSection(
                'Account',
                [
                  ListTile(
                    title: Text('Account Settings'),
                    trailing: Icon(_showAccountSettings ? Icons.expand_less : Icons.expand_more),
                    onTap: _toggleShowAccountSettings,
                  ),
                  if (_showAccountSettings) ...[
                    ListTile(
                      title: Text('Email'),
                      subtitle: Text(_pbService.user?.email ?? 'Not available'),
                    ),
                    ListTile(
                      title: Text('Username'),
                      subtitle: Text(_pbService.user?.username ?? 'Not available'),
                    ),
                    AnimatedSwitcher(duration: Duration(seconds: 1), child: _usernameField),
                    
                    

                    SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Implement password change
                      },
                      child: Text('Change Password'),
                    ),
                    SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Implement email change
                      },
                      child: Text('Change Email'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _pbService.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                      },
                      child: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
