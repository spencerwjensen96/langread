import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:langread/models/book.dart';
import 'package:langread/providers/SettingsProvider.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/views/reading_view.dart';
import 'package:provider/provider.dart';

class BookCard extends StatelessWidget {
  final LibraryBook book;
  
  final Function(BuildContext, LibraryBook)? onTap;

  void _defaultOnTap(BuildContext context, LibraryBook book) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReadingView(book: book),
        ),
      );
  }
  
  BookCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap != null ? onTap!(context, book) : _defaultOnTap(context, book);
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
                fontWeight: FontWeight.bold,
                fontSize: Provider.of<SettingsProvider>(context, listen: false)
                    .fontSize),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            book.author,
            style: TextStyle(
                fontSize: Provider.of<SettingsProvider>(context, listen: false)
                    .subfontSize),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
