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
  }

  BooksPocketbase booksService = PocketBaseService().books;

  Future<List<LibraryBook>> get books async => await _loadBooks();

  Future<LibraryBook> get lastBookRead async => await _loadLastBook();

  void setBookmark(LibraryBook book, int page) async {
    var bookmarks = prefs.getString('bookmarks');
    if (bookmarks == '' || bookmarks == null){
      await prefs.setString('bookmarks', jsonEncode({book.id: page}));
    }
    else {
      Map<String, dynamic> bookmarksMap = jsonDecode(bookmarks);
      bookmarksMap[book.id] = page;
      await prefs.setString('bookmarks', jsonEncode(bookmarksMap));
    }
  }

  void setLastBookRead(LibraryBook book) async {
    await prefs.setString('lastBookRead', jsonEncode(book));
    notifyListeners();
  }

  Future<void> downloadBook(LibraryBook book) async {
    await _addBookToLocalFile(book);
    await _addBookPagesToLocalFile(book.id);
    notifyListeners();
  }

  Future<int> getBookmark(String bookId) async {
    var bookmarks = prefs.getString('bookmarks');
    // print(bookmarks);
    if (bookmarks == '' || bookmarks == null){
      return 1;
    }
    Map<String, dynamic> bookmarksMap = jsonDecode(bookmarks);
    return bookmarksMap[bookId] ?? 1;
  }

  Future<void> deleteBook(LibraryBook book) async {
    print('deleting book ${book.id}');
  }

  Future<LibraryBook> _loadLastBook() async {
    if (prefs.getString('lastBookRead') != null){
      var json = jsonDecode(prefs.getString('lastBookRead'));
      return LibraryBook.fromJson(json);
    }
    else {
      var b = await books;
      if (b.isEmpty) {
        return LibraryBook.empty();
      }
      return b[0];
    }
  }

  Future<List<LibraryBook>> _loadBooks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/books.json');
    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode("[]"));
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
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/books/$id/pages.json');
      await file.create(recursive: true);
      await file.writeAsString(response.pages.join('\n'));
        } catch (e) {
      print('Error fetching book pages: $e');
    }
  }

  Future<void> _addBookToLocalFile(LibraryBook book) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/books.json');

    List<dynamic> books = [];
    if (await file.exists()) {
      final contents = await file.readAsString();
      books = jsonDecode(contents);
    }

    books.add({
      'id': book.id,
      'title': book.title,
      'author': book.author,
      'language': book.language,
      'genre': book.genre,
      'description': book.description,
      'coverUrl': book.coverUrl,
      'dateAdded': book.dateAdded.toIso8601String(),
    });

    await file.writeAsString(jsonEncode(books));
  }
}