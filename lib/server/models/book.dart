import 'dart:convert';

class LibraryBook {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final DateTime dateAdded;
  final String genre;
  final String language;
  int? lastPageRead;

  LibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.dateAdded,
    required this.genre,
    required this.language,
  });

  factory LibraryBook.fromJson(Map<String, dynamic> json) {
    if (jsonEncode(json) == "[]") {
      return LibraryBook.empty();
    }
    var book = LibraryBook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      coverUrl: json['coverUrl'],
      dateAdded: DateTime.parse(json['dateAdded']),
      genre: json['genre'],
      language: json['language'],
    );
    if (json['lastPageRead'] != null) {
      book.lastPageRead = json['lastPageRead'];
    }
    return book;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> book = {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'dateAdded': dateAdded.toIso8601String(),
      'genre': genre,
      'language': language,
    };
    if (lastPageRead != null) {
      book['lastPageRead'] = lastPageRead;
    }
    return book;
  }

  toList() {}

  static LibraryBook empty() {
    return LibraryBook(
      id: '',
      title: '',
      author: '',
      description: '',
      coverUrl: '',
      dateAdded: DateTime.now(),
      genre: '',
      language: '',
    );
  }
}

class BookPages {
  late final List<String> pages;

  BookPages({required this.pages});
}
