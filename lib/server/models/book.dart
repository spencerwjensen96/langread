class LibraryBook {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final DateTime dateAdded;
  final String genre;

  LibraryBook({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.dateAdded,
    required this.genre,
  });

  factory LibraryBook.fromJson(Map<String, dynamic> json) {
    return LibraryBook(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      coverUrl: json['coverUrl'],
      dateAdded: DateTime.parse(json['dateAdded']),
      genre: json['genre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'dateAdded': dateAdded.toIso8601String(),
      'genre': genre,
    };
  }

  toList() {}
}