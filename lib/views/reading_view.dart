import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:langread/views/components/SmoothPageView.dart';
import 'package:langread/views/home_screen.dart';
import 'package:langread/views/library_view.dart';
import '../models/settings.dart';


class ReadingView extends StatelessWidget {
var book;

ReadingView({super.key, this.book});

final Map<int, List<String>> samplePages = {
  0: [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
    "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  ],
  1: [
    "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.",
    "Totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.",
    "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.",
    "Sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
  ],
  2: [
    "Now I’m going to tell you about my brother. My brother, Jonathan Lionheart, is the person I want to tell you about. I think it’s almost like a saga, and just a little like a ghost story, and yet every word is true, though Jonathan and I are probably the only people who know that.",
    "Jonathan’s name wasn’t Lionheart from the start. His last name was Lion, just like Mother’s and mine. Jonathan Lion was his name. My name is Karl Lion and Mother’s is Sigrid Lion. Father was Axel Lion, but he went to sea and we never heard from him since."
  ]
};

@override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
        builder: (context, settings, child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title, style: TextStyle(fontSize: settings.superfontSize)),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (Route route) => false);
            }
          )
        ],
      ),
      body: SmoothPageView(pages: samplePages[book.id]!),
    );
        });
  }
}