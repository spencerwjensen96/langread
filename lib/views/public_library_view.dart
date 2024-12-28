import 'package:flutter/material.dart';
import 'package:bookbinding/server/methods/books.dart';
import 'package:bookbinding/server/models/book.dart';
import 'package:bookbinding/server/pocketbase.dart';
import 'package:bookbinding/views/components/BookCard.dart';

class PublicLibraryScreen extends StatefulWidget {
  const PublicLibraryScreen({Key? key}) : super(key: key);

  @override
  _PublicLibraryScreenState createState() => _PublicLibraryScreenState();
}

class _PublicLibraryScreenState extends State<PublicLibraryScreen> {
  final BooksPocketbase booksService = PocketBaseService().books;
  String languageLearning = 'swedish';
  List<LibraryBook> allBooks = [];
  List<LibraryBook> filteredBooks = [];
  String searchQuery = '';

  final List<String> availableLanguages = [
    'swedish',
    'spanish',
    'french',
    'german',
    'english'
  ];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    try {
      allBooks =
          await booksService.fetchLibraryBooks(language: languageLearning);
      _filterBooks();
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  void _filterBooks() {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredBooks = allBooks;
      } else {
        filteredBooks = allBooks
            .where((book) =>
                book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                book.author.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  void _onLanguageChanged(String? newLanguage) {
    if (newLanguage != null && newLanguage != languageLearning) {
      setState(() {
        languageLearning = newLanguage;
      });
    }
  }

  void Function(BuildContext, LibraryBook) _onBookTap(
      BuildContext context, LibraryBook book) {
    return (context, book) {
      Navigator.pushNamed(context, '/book', arguments: {'book': book});
    };
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Books'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
              _filterBooks();
            },
            decoration: const InputDecoration(
              hintText: 'Enter book title or author',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: filteredBooks.isEmpty
          ? const Center(child: Text('No books available'))
          : GridView.builder(
              padding: const EdgeInsets.all(32),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                return BookCard(
                    book: filteredBooks[index],
                    onTap: _onBookTap(context, filteredBooks[index]),
                    includeMenu: false);
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
