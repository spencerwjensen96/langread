import 'package:flutter/material.dart';
import 'package:langread/server/methods/books.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/server/pocketbase.dart';
import 'package:langread/views/components/BookCard.dart';

class PublicLibraryScreen extends StatelessWidget {

  final BooksPocketbase booksService = PocketBaseService().books;

  PublicLibraryScreen({super.key});

  Future<List<LibraryBook>> fetchBooks() async {
    try {
      return await booksService.fetchLibraryBooks();
      // return response.map((bookData) => Book.fromJson(bookData as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }

  void Function(BuildContext, LibraryBook) _onTap(BuildContext context, LibraryBook book) {
    return (context, book) {
      Navigator.pushNamed(context, '/book', arguments: {'book': book});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public Library'),
      ),
      body: FutureBuilder<List<LibraryBook>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books available'));
          } else {
            var books = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(32),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookCard(book: books[index], onTap: _onTap(context, books[index]),);
              },
            );
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:langread/server/methods/books.dart';
// import 'package:langread/server/models/book.dart';
// import 'package:langread/server/pocketbase.dart';
// import 'package:langread/views/components/BookCard.dart';

// class PublicLibraryScreen extends StatefulWidget {
//   PublicLibraryScreen({Key? key}) : super(key: key);

//   @override
//   _PublicLibraryScreenState createState() => _PublicLibraryScreenState();
// }

// class _PublicLibraryScreenState extends State<PublicLibraryScreen> {
//   BooksPocketbase booksService = PocketBaseService().books;
//   String? selectedGenre;
//   String? selectedLanguage;

//   List<String> genres = ['Fiction', 'Non-fiction', 'Mystery', 'Sci-Fi', 'Romance'];
//   List<String> languages = ['English', 'Swedish', 'Spanish', 'French', 'German'];

//   Future<List<LibraryBook>> fetchBooks() async {
//     try {
//       List<LibraryBook> books = await booksService.fetchLibraryBooks();
//       return books.where((book) {
//         bool genreMatch = selectedGenre == null || book.genre == selectedGenre;
//         bool languageMatch = selectedLanguage == null || book.language == selectedLanguage;
//         return genreMatch && languageMatch;
//       }).toList();
//     } catch (e) {
//       print('Error fetching books: $e');
//       return [];
//     }
//   }

//   void Function(BuildContext, LibraryBook) _onTap(BuildContext context, LibraryBook book) {
//     return (context, book) {
//       Navigator.pushNamed(context, '/book', arguments: {'book': book});
//     };
//   }

//   void _showFilterOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return Container(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Filter Books', style: Theme.of(context).textTheme.titleLarge),
//                   SizedBox(height: 16),
//                   Text('Genre', style: Theme.of(context).textTheme.titleMedium),
//                   DropdownButton<String>(
//                     isExpanded: true,
//                     value: selectedGenre,
//                     items: [
//                       DropdownMenuItem<String>(
//                         value: null,
//                         child: Text('All Genres'),
//                       ),
//                       ...genres.map((String genre) {
//                         return DropdownMenuItem<String>(
//                           value: genre,
//                           child: Text(genre),
//                         );
//                       }).toList(),
//                     ],
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedGenre = newValue;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 16),
//                   Text('Language', style: Theme.of(context).textTheme.titleMedium),
//                   DropdownButton<String>(
//                     isExpanded: true,
//                     value: selectedLanguage,
//                     items: [
//                       DropdownMenuItem<String>(
//                         value: null,
//                         child: Text('All Languages'),
//                       ),
//                       ...languages.map((String language) {
//                         return DropdownMenuItem<String>(
//                           value: language,
//                           child: Text(language),
//                         );
//                       }).toList(),
//                     ],
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedLanguage = newValue;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     child: Text('Apply Filters'),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       setState(() {});  // Trigger a rebuild of the main screen
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Public Library'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: _showFilterOptions,
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<LibraryBook>>(
//         future: fetchBooks(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No books available'));
//           } else {
//             var books = snapshot.data!;
//             return GridView.builder(
//               padding: const EdgeInsets.all(32),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 childAspectRatio: 0.7,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//               ),
//               itemCount: books.length,
//               itemBuilder: (context, index) {
//                 return BookCard(
//                   book: books[index],
//                   onTap: _onTap(context, books[index]),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }