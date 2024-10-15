import 'package:flutter/material.dart';
import 'package:langread/server/methods/books.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/server/pocketbase.dart';
import 'package:langread/views/components/AppBar.dart';
import 'package:langread/views/components/BookCard.dart';

class PublicLibraryScreen extends StatelessWidget {

  final BooksPocketbase booksService = PocketBaseService().books;

  final String languageLearning = 'swedish';

  PublicLibraryScreen({super.key});

  Future<List<LibraryBook>> fetchBooks() async {
    try {
      return await booksService.fetchLibraryBooks(language: languageLearning);
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  void Function(BuildContext, LibraryBook) _onTap(BuildContext context, LibraryBook book) {
    return (context, book) {
      Navigator.pushNamed(context, '/book', arguments: {'book': book});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: 'Public Library', homeButton: true,),
      body: FutureBuilder<List<LibraryBook>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books available'));
          } else {
            var books = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(32),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookCard(book: books[index], onTap: _onTap(context, books[index]), includeMenu: false,);
              },
            );
          }
        },
      ),
    );
  }
}
