import 'package:flutter/material.dart';
import 'package:langread/server/methods/books.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/server/pocketbase.dart';
import 'package:langread/views/components/BookCard.dart';

class PublicLibraryScreen extends StatefulWidget {
  const PublicLibraryScreen({Key? key}) : super(key: key);

  @override
  _PublicLibraryScreenState createState() => _PublicLibraryScreenState();
}

class _PublicLibraryScreenState extends State<PublicLibraryScreen> {
  final BooksPocketbase booksService = PocketBaseService().books;
  String languageLearning = 'swedish';

  final List<String> availableLanguages = [
    'swedish',
    'spanish',
    'french',
    'german',
    'english'
  ];

  Future<List<LibraryBook>> fetchBooks() async {
    try {
      return await booksService.fetchLibraryBooks(language: languageLearning);
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  void _onLanguageChanged(String? newLanguage) {
    if (newLanguage != null && newLanguage != languageLearning) {
      setState(() {
        languageLearning = newLanguage;
      });
    }
  }

  void Function(BuildContext, LibraryBook) _onTap(
      BuildContext context, LibraryBook book) {
    return (context, book) {
      Navigator.pushNamed(context, '/book', arguments: {'book': book});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Library'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        actions: [
          DropdownButton<String>(
            value: languageLearning,
            onChanged: _onLanguageChanged,
            items: availableLanguages.map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language.capitalize()),
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder<List<LibraryBook>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books available'));
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
                return BookCard(
                    book: books[index],
                    onTap: _onTap(context, books[index]),
                    includeMenu: false);
              },
            );
          }
        },
      ),
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
