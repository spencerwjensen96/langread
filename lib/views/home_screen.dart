// lib/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:bookbinding/providers/BookProvider.dart';
// import 'package:bookbinding/models/book.dart';
import 'package:bookbinding/server/models/book.dart';
import 'package:bookbinding/views/vocab_view.dart';
import 'package:provider/provider.dart';
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

  late LibraryBook lastBookRead;
  late Future<List<Widget>> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = Future.value([
      const LibraryView(),
      const CircularProgressIndicator(),
      const VocabListView(),
      SettingsView(),
    ]);
    _loadLastBookRead();
  }

  Future<void> _loadLastBookRead() async {
    lastBookRead =
        await Provider.of<BookProvider>(context, listen: false).lastBookRead;
    _widgetOptions = Future.value([
      const LibraryView(),
      ReadingView(book: lastBookRead),
      const VocabListView(),
      SettingsView(),
    ]);
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      index == 1 ? _isReading = true : _isReading = false;
    });
  }

  _buildHomeScreen(List<Widget> widgetOptions) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(widget.selectedIndex),
      ),
      bottomNavigationBar: _isReading
          ? null
          : BottomNavigationBar(
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
        future: _widgetOptions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books available'));
          } else {
            return _buildHomeScreen(snapshot.data!);
          }
        });
  }
}
