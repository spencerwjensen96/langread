  import 'package:flutter/material.dart';
import 'package:langread/server/models/book.dart';
import 'package:pocketbase/pocketbase.dart';


class BooksPocketbase {
  late final PocketBase _pb;

  BooksPocketbase(PocketBase pb) {
    _pb = pb;
  }

  Future<List<LibraryBook>> fetchLibraryBooks({int page = 1, int perPage = 20}) async {
    try {
      final response = await _pb.collection('library_books').getList(page: page, perPage: perPage);
      return response.items.map((item) {
        return LibraryBook(
          id: item.id,
          title: item.data['title'],
          author: item.data['author'],
          description: item.data['description'],
          coverUrl: item.data['cover_url'],
          dateAdded: DateTime.parse(item.created),
          genre: item.data['genre'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching books: $e');
      return [];
    }
  }
}