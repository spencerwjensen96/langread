import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../models/settings.dart';
import 'reading_view.dart';

class LibraryView extends StatelessWidget {
  final List<BookModel> books = [
    BookModel(
        id: 0,
        title: 'Sample Book 1',
        author: 'Author 1',
        coverUrl: 'file:///Users/spencer.jensen/Library/Developer/CoreSimulator/Devices/1262FDE7-05FC-4F40-8F94-C1A44F186F2E/data/Containers/Data/Application/E2661582-DE75-4534-9949-211D0101CE83/Documents/150.png'),
    BookModel(
        id: 1,
        title: 'Sample Book 2',
        author: 'Author 2',
        coverUrl: 'file:///Users/spencer.jensen/Library/Developer/CoreSimulator/Devices/1262FDE7-05FC-4F40-8F94-C1A44F186F2E/data/Containers/Data/Application/E2661582-DE75-4534-9949-211D0101CE83/Documents/150.png'),
    BookModel(
        id: 2,
        title: 'Brothers Lionheart',
        author: 'Astrid Lindgren',
        coverUrl: 'file:///Users/spencer.jensen/Library/Developer/CoreSimulator/Devices/1262FDE7-05FC-4F40-8F94-C1A44F186F2E/data/Containers/Data/Application/E2661582-DE75-4534-9949-211D0101CE83/Documents/150.png'),
    BookModel(
        id: 3,
        title: 'Broderna Lejonhjarta',
        author: 'Astrid Lindgren',
        coverUrl:
            'https://somewhereboy.wordpress.com/wp-content/uploads/2017/09/the-brothers-lionheart.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(builder: (context, settings, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Library',
              style: TextStyle(fontSize: settings.superfontSize)),
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
          onPressed: () async {
            // var result_file = importFile();
          },
          tooltip: 'Import Book',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}

class BookCard extends StatelessWidget {
  final BookModel book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(builder: (context, settings, child) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadingView(book: book),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: book.coverUrl.startsWith('file://')
                  ? Image.file(
                      File(book.coverUrl.replaceFirst(RegExp(r'file://'), '')),
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      book.coverUrl,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              book.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: settings.fontSize),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              book.author,
              style: TextStyle(fontSize: settings.fontSize - 4),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    });
  }
}
