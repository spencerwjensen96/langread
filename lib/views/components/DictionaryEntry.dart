import 'dart:io';

import 'package:flutter/material.dart';
import 'package:langread/models/vocabulary_item.dart';
import 'package:langread/providers/DictionaryProvider.dart';
import 'package:langread/providers/VocabProviders.dart';
import 'package:langread/utils/deepl.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

class DictionaryEntryWidget extends StatefulWidget {
  final String word;
  final String context;

  const DictionaryEntryWidget({Key? key, required this.word, required this.context})
      : super(key: key);

  @override
  _DictionaryEntryState createState() => _DictionaryEntryState();
}

class _DictionaryEntryState extends State<DictionaryEntryWidget> {
  late Future<Map<String, dynamic>> _wordInfo;

  @override
  void initState() {
    super.initState();
    // _wordInfo = fetchWordInfo(widget.word);
    var dictionaryProvider = Provider.of<DictionaryProvider>(context, listen: false);
    _wordInfo = fetchWordInfo(widget.word, widget.context, dictionaryProvider);
  }

  Future<Map<String, dynamic>> fetchWordInfo(
      String word, String context, DictionaryProvider provider) async {
    final translation = await fetchTranslation(word, context);
    final examples = await fetchExamples(word);
    final synonyms = await fetchSynonyms(word);
    
    // var entries = await provider.entrys(word, 'sv-en');

    // DictionaryEntry? dictEntry;
    
    // print("${entries.length} entries in dict.");
    // for (var e in entries){
    //   var document = XmlDocument.parse(e.entry);
    //   for (var node in document.children){
    //     // print(node.attributes.map((e) => e.toString()));

    //     if(node.getAttribute('d:title') != null){
    //       dictEntry = DictionaryEntry.fromXml(node);
    //       print(dictEntry.title);
    //       print(dictEntry.definitions);
    //       print(dictEntry.examples);
    //       print(dictEntry.pronunciation);
    //     }
        
    //   }
    // }
    
    

    

    return {
      'translation': translation,
      'examples': examples,
      'synonyms': synonyms,
    };
  }

  Future<String> fetchTranslation(String word, String context) async {
    // var response = await DeepL.translateText(
    //     text: word, sourceLang: 'sv', targetLang: 'en', context: context);
    var response = 'temp.';
    if (response == null) {
      return 'Translation not found';
    }
    return response;
  }

  Future<List<Example>> fetchExamples(String word) async {
    // Implement example fetching logic here
    return [
      Example(example: 'TODO examples', translation: 'here'),
      Example(example: 'example 2', translation: 'here')
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
        } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No dictionary entry available'));
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
                  // _buildExamplesSection('Examples', wordInfo['examples']),
                  // _buildListSection('Synonyms', wordInfo['synonyms']),
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
  Widget _buildExamplesSection(String title, List<Example> items) {
    // print(items);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.asMap().entries.map((item) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Column(
                children: [
                  Text('• ${item.value.example}'),
                  Text('• ${item.value.translation}', style: TextStyle(color: Colors.grey[300]),)
                ],
              )

            )),
        const SizedBox(height: 16),
      ],
    );
  }
}
