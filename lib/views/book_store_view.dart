import 'package:flutter/material.dart';
import 'package:bookbinding/views/components/AppBar.dart';

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