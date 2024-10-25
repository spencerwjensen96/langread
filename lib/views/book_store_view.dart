import 'package:flutter/material.dart';
import 'package:langread/views/components/AppBar.dart';
import 'package:langread/views/components/EpubReader.dart';

class BookStoreScreen extends StatelessWidget {

  const BookStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainAppBar(title: 'Book Store', homeButton: true),
      body: Center(
        // child: Text('Book Store'),
        child: EpubReader()
      ),
    );
  }
}