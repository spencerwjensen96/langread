import 'dart:ffi';

// import 'package:uuid/uuid.dart';

// lib/models/book.dart
class Book {
  final int id;
  final String title;
  final String author;
  final String coverUrl;

  Book({required this.id, required this.title, required this.author, required this.coverUrl});
}