import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bookbinding/providers/SettingsProvider.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final bool homeButton;
  final List<Widget>? additionalActions;

  const MainAppBar({super.key, required this.title, required this.homeButton, this.additionalActions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(fontSize: Provider.of<SettingsProvider>(context).fontSize),),
      actions: [
        homeButton ?
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                  }
                ) : Container(),
        if (additionalActions != null) ...additionalActions!,
              ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}