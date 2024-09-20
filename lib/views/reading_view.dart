import 'package:flutter/material.dart';
import 'package:langread/views/components/SmoothPageView.dart';
import 'package:langread/views/home_screen.dart';
import 'package:langread/views/library_view.dart';


class ReadingView extends StatelessWidget {
var book;

ReadingView({super.key, this.book});

final samplePages = [
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
  "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
  "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
];

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),);
            }
          )
        ],
      ),
      body: SmoothPageView(pages: samplePages),
    );
  }
}