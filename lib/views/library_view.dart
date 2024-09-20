// lib/views/library_view.dart
import 'package:flutter/material.dart';
import 'package:langread/views/home_screen.dart';
// import 'package:uuid/uuid.dart';
import '../models/book.dart';
import '../utils/library_utils.dart';
import 'reading_view.dart';

class LibraryView extends StatelessWidget {
  final List<Book> books = [
    Book(id: 0, title: 'Sample Book 1', author: 'Author 1', coverUrl: 'https://via.placeholder.com/150'),
    Book(id: 1, title: 'Sample Book 2', author: 'Author 2', coverUrl: 'https://via.placeholder.com/150'),
    Book(id: 2, title: 'Broderna Lejonhjarta', author: 'Astrid Lindgren', coverUrl: 'https://via.placeholder.com/150'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
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
          var result_file = importFile();
        },
        tooltip: 'Import Book',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
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
            child: Image.network(
              book.coverUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            book.author,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}