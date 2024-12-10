import 'package:flutter/material.dart';
import 'package:bookbinding/providers/SettingsProvider.dart';
import 'package:bookbinding/views/components/AppBar.dart';
import 'package:provider/provider.dart';
import '../../providers/VocabProviders.dart';

class VocabularyList extends StatelessWidget {
  const VocabularyList({super.key});

  deleteButton (context) => IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Vocabulary'),
                  content: const Text('Are you sure you want to clear all vocabulary items?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('Clear'),
                      onPressed: () async {
                        await Provider.of<VocabularyProvider>(context, listen: false).clearAll();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: 'Vocabulary List', homeButton: false, additionalActions: [deleteButton(context)],),
      body: Consumer<VocabularyProvider>(
        builder: (context, vocabularyProvider, child) {
          if (vocabularyProvider.items.isEmpty) {
            return const Center(
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
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await vocabularyProvider.removeItem(item);
                },
                child: ListTile(
                  title: Text(item.word, style: TextStyle(fontSize: Provider.of<SettingsProvider>(context).fontSize)),
                  subtitle: Text(item.translation, style: TextStyle(fontSize: Provider.of<SettingsProvider>(context).subfontSize)),
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
                            const SizedBox(height: 8),
                            Text('Example: ${item.sentence}'),
                            const SizedBox(height: 8),
                            Text('Added: ${item.dateAdded.toString().split(' ')[0]}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Delete Word'),
                            onPressed: () => {
                                vocabularyProvider.removeItem(item),
                                Navigator.of(context).pop(),
                              }
                          ),
                          TextButton(
                            child: const Text('Close'),
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
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: Implement add new vocabulary item functionality
        },
      ),
    );
  }
}
