import 'package:flutter/material.dart';
import 'package:deepl_dart/deepl_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langread/models/vocabulary_item.dart';
import 'package:langread/providers/VocabProviders.dart';
import 'package:provider/provider.dart';

class DictionaryEntry extends StatefulWidget {
  final String word;

  const DictionaryEntry({Key? key, required this.word}) : super(key: key);

  @override
  _DictionaryEntryState createState() => _DictionaryEntryState();
}

class _DictionaryEntryState extends State<DictionaryEntry> {
  late Future<Map<String, dynamic>> _wordInfo;
  final Translator translator =
      Translator(authKey: dotenv.env['DEEPL_API_KEY']!);

  @override
  void initState() {
    super.initState();
    _wordInfo = fetchWordInfo(widget.word);
  }

  Future<Map<String, dynamic>> fetchWordInfo(String word) async {
    final translation = await fetchTranslation(word);
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

  Future<String> fetchTranslation(String word) async {
    final result = await translator.translateTextSingular(
      word,
      'en',
      sourceLang: 'sv',
    );
    return result.text;
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
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 300,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          final wordInfo = snapshot.data!;
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
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
                    // _buildSection('Definition', wordInfo['definition']),
                    // _buildListSection('Examples', wordInfo['examples']),
                    // _buildListSection('Synonyms', wordInfo['synonyms']),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        print('pressed add vocab button');
                        await Provider.of<VocabularyProvider>(context, listen: false).addItem(VocabularyItemModel(
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
