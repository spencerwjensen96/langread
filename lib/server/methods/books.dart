import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:langread/server/models/book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocketbase/pocketbase.dart';

class BooksPocketbase {
  late final PocketBase _pb;

  BooksPocketbase(PocketBase pb) {
    _pb = pb;
  }

  Future<List<LibraryBook>> fetchLibraryBooks(
      {int page = 1, int perPage = 20, String language = ''}) async {
    try {
      final response = await _pb
          .collection('library_books')
          .getList(query: {'language': language}, page: page, perPage: perPage);
      return response.items.map((item) {
        return LibraryBook(
          id: item.id,
          title: item.data['title'],
          author: item.data['author'],
          description: item.data['description'],
          coverUrl: item.data['cover_url'],
          dateAdded: DateTime.parse(item.created),
          genre: item.data['genre'],
          language: item.data['language'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching books: $e');
      return [];
    }
  }

  Future<BookPages> fetchBookPages(String id) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/books/$id/pages.json');

    if (!await file.exists()) {
      try {
        final pb_response = await _pb
            .collection('book_pages')
            .getFirstListItem('book.id="$id"');
        var url = _pb.files.getUrl(pb_response, pb_response.data['pages_file'], query: {'download': true});
        final httpClient = HttpClient();
        final request = await httpClient.getUrl(url);
        final http_response = await request.close();
        final bytes = await consolidateHttpClientResponseBytes(http_response);
        await file.create(recursive: true);
        await file.writeAsBytes(bytes);
      } catch (e) {
        throw Exception('Error fetching books: $e');
      }
    }
    final contents = await file.readAsString();
    final List<String> jsonData = const LineSplitter().convert(contents);
    return BookPages(pages: jsonData);
    }

    Future<File> fetchBookFile(String bookId) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/books/$bookId/$bookId.epub');
    print("${directory.path}/books/$bookId/");

    if (!await file.exists()) {
      try {
        final pb_response = await _pb
            .collection('book_files')
            .getFirstListItem('book.id="$bookId"');
        var url = _pb.files.getUrl(pb_response, pb_response.data['epub_file'], query: {'download': true});
        final httpClient = HttpClient();
        final request = await httpClient.getUrl(url);
        final http_response = await request.close();
        final bytes = await consolidateHttpClientResponseBytes(http_response);
        await file.create(recursive: true);
        await file.writeAsBytes(bytes);
      } catch (e) {
        throw Exception('Error fetching books: $e');
      }
    }

    return file;
}
}

