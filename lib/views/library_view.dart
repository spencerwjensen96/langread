import 'package:flutter/material.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/views/components/BookCard.dart';
import 'package:provider/provider.dart';
import '../providers/SettingsProvider.dart';
import '../providers/BookProvider.dart';

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late Future<List<LibraryBook>> books;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    books = Provider.of<BookProvider>(context, listen: true).books;
  }



  void _showOptionsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: 150,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.library_books),
                title: Text('Public Library'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/public-library');
                },
              ),
              ListTile(
                leading: Icon(Icons.store),
                title: Text('Book Store'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/bookstore');
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: books, builder: 
      (context, AsyncSnapshot<List<LibraryBook>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('An error occurred'));
        } else {
          return _buildLibraryView(snapshot.data!);
        }
      }
    );
  }

  _buildLibraryView(List<LibraryBook> books) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Library',
            style: TextStyle(
                fontSize: Provider.of<SettingsProvider>(context, listen: false)
                    .superfontSize)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(book: books[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOptionsModal(context),
        tooltip: 'Import Book',
        child: const Icon(Icons.add),
      ),
    );
  }
}
