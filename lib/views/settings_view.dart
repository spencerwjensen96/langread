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
                            decoration: const InputDecoration(
                              labelText: 'New Username',
                              border: OutlineInputBorder(),
                            ),
                            // style: TextStyle(fontSize: Provider.of<SettingsProvider>(context).fontSize),
                          ),
                        ),
                        SizedBox(width: 8),
                        TextButton(
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
              style: TextStyle(fontSize: Provider.of<SettingsProvider>(context).superfontSize,
              fontWeight: FontWeight.bold),
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

    var settings = context.watch<SettingsProvider>();
  //   return Consumer<SettingsProvider>(
  // builder: (context, settings, child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              _buildSettingSection(
                'Reading Settings',
                [
                  ListTile(
                    title: Text('Font Size', style: TextStyle(fontSize: settings.fontSize)),
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
                    title: Text('Line Height', style: TextStyle(fontSize: settings.fontSize)),
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
                    title: Text('Theme', style: TextStyle(fontSize: settings.fontSize)),
                    trailing: DropdownButton<ThemeMode>(
                      value: settings.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) settings.setThemeMode(value);
                      },
                      items: [
                        DropdownMenuItem(value: ThemeMode.system, child: Text('System', style: TextStyle(fontSize: settings.fontSize))),
                        DropdownMenuItem(value: ThemeMode.light, child: Text('Light', style: TextStyle(fontSize: settings.fontSize))),
                        DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark', style: TextStyle(fontSize: settings.fontSize))),
                      ],
                    ),
                  ),
                ],
              ),
              _buildSettingSection(
                'Account',
                [
                  ListTile(
                    title: Text('Account Settings', style: TextStyle(fontSize: settings.fontSize)),
                    trailing: Icon(_showAccountSettings ? Icons.expand_less : Icons.expand_more),
                    onTap: _toggleShowAccountSettings,
                  ),
                  if (_showAccountSettings) ...[
                    ListTile(
                      title: Text('Email', style: TextStyle(fontSize: settings.fontSize)),
                      subtitle: Text(_pbService.user?.email ?? 'Not available', style: TextStyle(fontSize: settings.subfontSize)),
                    ),
                    ListTile(
                      title: Text('Username', style: TextStyle(fontSize: settings.fontSize)),
                      subtitle: Text(_pbService.user?.username ?? 'Not available', style: TextStyle(fontSize: settings.subfontSize)),
                    ),
                    AnimatedSwitcher(duration: Duration(seconds: 1), child: _usernameField),
                    
                    

                    SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Implement password change
                      },
                      child: Text('Change Password', style: TextStyle(fontSize: settings.fontSize)),
                    ),
                    SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Implement email change
                      },
                      child: Text('Change Email', style: TextStyle(fontSize: settings.fontSize)),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        _pbService.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                      },
                      child: Text('Logout', style: TextStyle(fontSize: settings.fontSize)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
  //     );
  // }
    );
  }
}
