import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:bookbinding/server/models/book.dart';
import 'package:bookbinding/server/models/enums.dart';
import 'package:bookbinding/utils/utils.dart';
import 'package:bookbinding/views/components/AppBar.dart';
import 'package:bookbinding/views/components/BookCard.dart';
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
          height: 180,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.library_books),
                title: const Text('Public Library'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/public-library');
                },
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('Book Store'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/bookstore');
                },
              ),
              ListTile(
                leading: const Icon(Icons.devices),
                title: const Text('Add From Device'),
                onTap: () async {
                  File uploadFile;
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['epub'],
                  );

                  if (result != null) {
                    PlatformFile file = result.files.first;
                    uploadFile = File(file.path!);
                  } else {
                    return;
                  }
                  String? title;
                  String? author;
                  String? language;
                  String? genre;

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Enter Book Details'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Title'),
                              onChanged: (value) {
                                title = value;
                              },
                            ),
                            TextField(
                              decoration:
                                  const InputDecoration(labelText: 'Author'),
                              onChanged: (value) {
                                author = value;
                              },
                            ),
                            DropdownMenu(
                              label: const Text('Language'),
                              dropdownMenuEntries:
                                  Language.values.map((Language language) {
                                return DropdownMenuEntry(
                                  value: language,
                                  label: language.displayName.toCapitalized,
                                );
                              }).toList(),
                              onSelected: (Language? value) {
                                setState(() {
                                  language = value?.name;
                                });
                              },
                            ),
                            DropdownMenu(
                              label: const Text('Genre'),
                              dropdownMenuEntries:
                                  BookGenre.values.map((BookGenre genre) {
                                return DropdownMenuEntry(
                                  value: genre,
                                  label: genre.displayName.toTitleCase,
                                );
                              }).toList(),
                              onSelected: (BookGenre? value) {
                                setState(() {
                                  genre = value?.name;
                                });
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Submit'),
                            onPressed: () async {
                              if (title == null ||
                                  author == null ||
                                  language == null ||
                                  genre == null) {
                                return;
                              }
                              await Provider.of<BookProvider>(context,
                                      listen: false)
                                  .uploadEpubFile(
                                uploadFile,
                                title: title!,
                                author: author!,
                                language: language!,
                                genre: genre!,
                              );
                              print('upload epub');
                              Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
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
    return FutureBuilder(
        future: books,
        builder: (context, AsyncSnapshot<List<LibraryBook>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          } else {
            return _buildLibraryView(snapshot.data!,
                MediaQuery.of(context).size.width < 600 ? 2 : 3);
          }
        });
  }

  _buildLibraryView(List<LibraryBook> books, int axisCount) {
    return Scaffold(
      appBar: const MainAppBar(title: 'My Library', homeButton: false),
      body: books.isEmpty
          ? const EmptyLibraryCard()
          : GridView.builder(
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
