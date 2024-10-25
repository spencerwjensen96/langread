import 'dart:io';

import 'package:flutter/material.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/views/components/AppBar.dart';
import 'package:langread/views/components/EpubReader.dart';

class BookStoreScreen extends StatelessWidget {

  const BookStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Book Store', homeButton: true),
      body: Center(
        child: Text('Book Store'),
    ),
    );
  }
}