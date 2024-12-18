import 'package:flutter/material.dart';
import 'package:bookbinding/providers/BookProvider.dart';
import 'package:bookbinding/server/models/book.dart';
import 'package:bookbinding/views/components/AppBar.dart';
import 'package:provider/provider.dart';

class LibraryBookDetailView extends StatelessWidget {
  final LibraryBook book;
  // BooksPocketbase booksService = PocketBaseService().books;

  const LibraryBookDetailView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: book.title, homeButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                book.coverUrl,
                height: 200,
              ),
            ),
            SizedBox(height: 16),
            Text(
              book.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Author: ${book.author}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Language: ${book.language}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Genre: ${book.genre}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              book.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  print('downloading ${book.toString()}');
                  await Provider.of<BookProvider>(context, listen: false).downloadBook(book);
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Download successful!'),
                      action: SnackBarAction(
                      label: 'Go Back',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      ),
                    ),
                    );
                },
                child: Text('Download to Personal Library'))
          ],
        ),
      ),
    );
  }
}
