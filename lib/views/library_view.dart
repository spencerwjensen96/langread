import 'dart:io';

import 'package:flutter/material.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/views/components/BookCard.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/SettingsProvider.dart';
import 'reading_view.dart';

class LibraryView extends StatelessWidget {
  final List<LibraryBook> books = [
    LibraryBook(
        id: '0',
        title: 'Sample Book 1',
        description: '',
        genre: '',
        dateAdded: DateTime.now(),
        author: 'Author 1',
        coverUrl:
            'file:///Users/spencer.jensen/Library/Developer/CoreSimulator/Devices/1262FDE7-05FC-4F40-8F94-C1A44F186F2E/data/Containers/Data/Application/E2661582-DE75-4534-9949-211D0101CE83/Documents/150.png'),
    LibraryBook(
        id: '1',
        title: 'Sample Book 2',
        description: '',
        genre: '',
        dateAdded: DateTime.now(),
        author: 'Author 2',
        coverUrl:
            'file:///Users/spencer.jensen/Library/Developer/CoreSimulator/Devices/1262FDE7-05FC-4F40-8F94-C1A44F186F2E/data/Containers/Data/Application/E2661582-DE75-4534-9949-211D0101CE83/Documents/150.png'),
    LibraryBook(
        id: '2',
        title: 'Brothers Lionheart',
        description: '',
        genre: '',
        dateAdded: DateTime.now(),
        author: 'Astrid Lindgren',
        coverUrl:
            'file:///Users/spencer.jensen/Library/Developer/CoreSimulator/Devices/1262FDE7-05FC-4F40-8F94-C1A44F186F2E/data/Containers/Data/Application/E2661582-DE75-4534-9949-211D0101CE83/Documents/150.png'),
    LibraryBook(
        id: '3',
        title: 'Broderna Lejonhjarta',
        description: '',
        genre: '',
        dateAdded: DateTime.now(),
        author: 'Astrid Lindgren',
        coverUrl:
            'https://somewhereboy.wordpress.com/wp-content/uploads/2017/09/the-brothers-lionheart.jpg'),
  ];

  void _showOptionsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: 150,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.library_books),
                title: Text('Public Library'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/public-library');
                },
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text('Book Store'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/bookstore');
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Library',
            style: TextStyle(
                fontSize: Provider.of<SettingsProvider>(context, listen: false)
                    .superfontSize)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(book: books[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOptionsModal(context),
        tooltip: 'Import Book',
        child: const Icon(Icons.add),
      ),
    );
  }
}
