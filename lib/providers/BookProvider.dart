import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:langread/server/methods/books.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/server/pocketbase.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookProvider extends ChangeNotifier{
  late final prefs;

  BookProvider(SharedPreferencesWithCache prefsWithCache){
    prefs = prefsWithCache;
    print("last book: ${prefs.getString('lastBookRead')}");
  }

  BooksPocketbase booksService = PocketBaseService().books;

  Future<List<LibraryBook>> get books async => await _loadBooks();

  Future<LibraryBook> get lastBookRead async => await _loadLastBook();

  void setLastBookRead(LibraryBook book) async {
    await prefs.setString('lastBookRead', jsonEncode(book));
    notifyListeners();
  }

  Future<void> downloadBook(LibraryBook book) async {
    await _addBookToLocalFile(book);
    await _addBookPagesToLocalFile(book.id);
    notifyListeners();
  }

  Future<LibraryBook> _loadLastBook() async {
    if (prefs.getString('lastBookRead') != null){
      return LibraryBook.fromJson(jsonDecode(prefs.getString('lastBookRead')));
    }
    else {
      return (await books)[0];
    }
  }

  Future<List<LibraryBook>> _loadBooks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/books.json');
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode([]));
      return [];
    }
    final contents = await file.readAsString();
    final List<dynamic> jsonData = json.decode(contents);
    return jsonData.map((json) => LibraryBook.fromJson(json)).toList();
  }

  Future<bool> _bookAlreadyDownloaded(String id) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/books/$id');
    if (file.existsSync()) {
      return true;
    }
    return false;
  }

  Future<void> _addBookPagesToLocalFile(String id) async {
    try {
      var isDownloaded = await _bookAlreadyDownloaded(id);
      if (isDownloaded){
        print('Book already downloaded');
        return;
      }
      final response = await booksService.fetchBookPages(id);
      if (response != null) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/books/$id/pages.json');
        await file.create(recursive: true);
        await file.writeAsString(response.pages.join('\n'));
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      print('Error fetching book pages: $e');
    }
  }

  Future<void> _addBookToLocalFile(LibraryBook book) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/books.json');

    List<LibraryBook> books = [];
    if (await file.exists()) {
      final contents = await file.readAsString();
      books = jsonDecode(contents);
    }

    books.add({
      'id': book.id,
      'title': book.title,
      'author': book.author,
      'genre': book.genre,
      'description': book.description,
      'coverUrl': book.coverUrl,
      'dateAdded': book.dateAdded.toIso8601String(),
    } as LibraryBook);

    await file.writeAsString(jsonEncode(books));
  }
}