// lib/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:langread/models/book.dart';
import 'package:langread/views/vocab_view.dart';
import 'library_view.dart';
import 'reading_view.dart';
import 'settings_view.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {

  int selectedIndex;

  HomeScreen({super.key, required this.selectedIndex});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _selectedIndex = widget.selectedIndex;
  bool _isReading = false;
  
  static BookModel lastReadBook = BookModel(
      id: 0,
      title: 'Sample Book 1',
      author: 'Author 1',
      coverUrl: 'https://via.placeholder.com/150');

  static final List<Widget> _widgetOptions = <Widget>[
    LibraryView(),
    ReadingView(book: lastReadBook),
    VocabListView(),
    SettingsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      index == 1 ? _isReading = true : _isReading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(widget.selectedIndex),
      ),
      bottomNavigationBar: _isReading ? null : BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
        icon: Icon(Icons.library_books),
        label: 'Library',
          ),
          BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Read',
          ),
          BottomNavigationBarItem(
        icon: Icon(Icons.list),
        label: 'Vocab',
          ),
          BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
          ),
          
        ],
        currentIndex: widget.selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
