import 'package:flutter/material.dart';
import 'package:langread/views/components/AppBar.dart';

class BookStoreScreen extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainAppBar(title: 'Book Store', homeButton: true),
      body: Center(
        child: Text('Book Store'),
      ),
    );
  }
}