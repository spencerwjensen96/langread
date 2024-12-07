import 'dart:io';

import 'package:flutter/material.dart';
import 'package:langread/providers/BookProvider.dart';
import 'package:langread/server/methods/books.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/server/pocketbase.dart';
import 'package:langread/views/components/AppBar.dart';
import 'package:langread/views/components/EpubReader.dart';
import 'package:provider/provider.dart';

class ReadingView extends StatefulWidget {
  final LibraryBook book;
  final BooksPocketbase booksService = PocketBaseService().books;

  ReadingView({super.key, required this.book});

  @override
  State<StatefulWidget> createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView> {
  late Future<File> _bookFile;

 @override
  void initState(){
    super.initState();
    // _pages = widget.booksService.fetchBookPages(widget.book.id);
    _bookFile = widget.booksService.fetchBookFile(widget.book.id);
    Provider.of<BookProvider>(context, listen: false).setLastBookRead(widget.book);
  }

@override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _bookFile,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: MainAppBar(title: widget.book.title, homeButton: true),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: MainAppBar(title: widget.book.title, homeButton: true),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          final File file = snapshot.data!;
          return Scaffold(
            appBar: MainAppBar(title: widget.book.title, homeButton: true),
            body: EpubReader(book: widget.book, bookFile: file),
          );
        }
      },
    );
  }
}