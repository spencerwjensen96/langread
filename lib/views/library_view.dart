import 'package:flutter/material.dart';
import 'package:langread/server/models/book.dart';
import 'package:langread/views/components/AppBar.dart';
import 'package:langread/views/components/BookCard.dart';
import 'package:provider/provider.dart';
import '../providers/BookProvider.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

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
          return _buildLibraryView(snapshot.data!, MediaQuery.of(context).size.width < 600 ? 2 : 3);
        }
      }
    );
  }

  _buildLibraryView(List<LibraryBook> books, int axisCount) {

    return Scaffold(
      appBar: MainAppBar(title: 'My Library', homeButton: false),
      body: GridView.builder(
        padding: const EdgeInsets.all(32),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: axisCount,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(book: books[index], includeMenu: true);
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
