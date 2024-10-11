import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langread/models/vocabulary_item.dart';
import 'package:langread/providers/VocabProviders.dart';
import 'package:langread/utils/deepl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

class DictionaryEntry extends StatefulWidget {
  final String word;
  final String context;

  const DictionaryEntry({Key? key, required this.word, required this.context})
      : super(key: key);

  @override
  _DictionaryEntryState createState() => _DictionaryEntryState();
}

class _DictionaryEntryState extends State<DictionaryEntry> {
  late Future<Map<String, dynamic>> _wordInfo;

  @override
  void initState() {
    super.initState();
    // _wordInfo = fetchWordInfo(widget.word);
    _wordInfo = fetchWordInfo(widget.word, widget.context);
  }

  Future<Map<String, dynamic>> fetchWordInfo(
      String word, String context) async {
    final translation = await fetchTranslation(word, context);
    final definition = await fetchDefinition(word);
    final examples = await fetchExamples(word);
    final synonyms = await fetchSynonyms(word);

    return {
      'translation': translation,
      'definition': definition,
      'examples': examples,
      'synonyms': synonyms,
    };
  }

  //   Future<Map<String, dynamic>> fetchWordInfo(String word) async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final file = File('${directory.path}/dictionaries/sv-en.xml');
  //     var re = RegExp('^.*d:title="${word.toLowerCase()}"[^\n]*');

  //     var entries = re.allMatches(file.readAsStringSync());
  //     for (var entry in entries) {
  //       print(entry.group(0));
  //     }

  //     return {
  //       'translation': 'translation',
  //       'definition': 'definition',
  //       'partOfSpeech': 'partOfSpeech',
  //       'examples': 'examples',
  //       'synonyms': 'synonyms',
  //     };
  //   } catch (e) {
  //     print('Error fetching word info: $e');
  //     return {
  //       'error': 'Word not found or error occurred',
  //     };
  //   }
  // }

  Future<String> fetchTranslation(String word, String context) async {
    var response = await DeepL.translateText(
        text: word, sourceLang: 'sv', targetLang: 'en', context: context);
    if (response == null) {
      return 'Translation not found';
    }
    return response;
  }

  Future<String> fetchDefinition(String word) async {
    return 'TODO: Implement definitions';
  }

  Future<List<String>> fetchExamples(String word) async {
    // Implement example fetching logic here
    return [
      'TODO: Implement examples',
      'Example 1 with $word',
      'Example 2 with $word'
    ];
  }

  Future<List<String>> fetchSynonyms(String word) async {
    // Implement synonym fetching logic here
    return ['TODO: Implement synonyms', 'Synonym 1', 'Synonym 2'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _wordInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || snapshot.data!['error'] != null) {
          return SizedBox(
            height: 300,
            child: Center(
                child: Text(
                    'Error: ${snapshot.error ?? ''} ${snapshot.data!['error'] ?? ''}')),
          );
        } else {
          final wordInfo = snapshot.data!;
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.word,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildSection('Translation', wordInfo['translation']),
                  _buildSection('Definition', wordInfo['definition']),
                  _buildListSection('Examples', wordInfo['examples']),
                  _buildListSection('Synonyms', wordInfo['synonyms']),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      print('pressed add vocab button');
                      await Provider.of<VocabularyProvider>(context,
                              listen: false)
                          .addItem(VocabularyItemModel(
                              word: widget.word,
                              translation: wordInfo['translation'],
                              sentence: "example sentence",
                              dateAdded: DateTime.now()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add to Vocabulary List'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text('• $item'),
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}
