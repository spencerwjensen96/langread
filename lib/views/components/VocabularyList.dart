// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:langread/providers/VocabProviders.dart';

// class VocabularyList extends StatefulWidget {
//   const VocabularyList({super.key});

//   @override
//   State<StatefulWidget> createState() => _VocabularyListState();
// }

// class _VocabularyListState extends State<VocabularyList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Vocabulary List'),
//         ),
//         body: ListView(padding: EdgeInsets.all(16), children: [
//           for (var i in VocabularyProvider().items)
//             ListTile(
//               title: Text('Word ${i.word}'),
//               subtitle: Text('Definition ${i.translation}'),
//             ),
//         ]));
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/VocabProviders.dart';
import '../../models/vocabulary_item.dart';

class VocabularyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vocabulary List'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear Vocabulary'),
                  content: Text('Are you sure you want to clear all vocabulary items?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text('Clear'),
                      onPressed: () async {
                        await Provider.of<VocabularyProvider>(context, listen: false).clearAll();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<VocabularyProvider>(
        builder: (context, vocabularyProvider, child) {
          if (vocabularyProvider.items.isEmpty) {
            return Center(
              child: Text('Your vocabulary list is empty.'),
            );
          }
          return ListView.builder(
            itemCount: vocabularyProvider.items.length,
            itemBuilder: (context, index) {
              final item = vocabularyProvider.items[index];
              return Dismissible(
                key: Key(item.word),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await vocabularyProvider.removeItem(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.word} removed from vocabulary')),
                  );
                },
                child: ListTile(
                  title: Text(item.word),
                  subtitle: Text(item.translation),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(item.word),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Translation: ${item.translation}'),
                            SizedBox(height: 8),
                            Text('Example: ${item.sentence}'),
                            SizedBox(height: 8),
                            Text('Added: ${item.dateAdded.toString().split(' ')[0]}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('Close'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // TODO: Implement add new vocabulary item functionality
        },
      ),
    );
  }
}
