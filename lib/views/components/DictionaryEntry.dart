import 'package:flutter/material.dart';
import 'package:bookbinding/models/vocabulary_item.dart';
import 'package:bookbinding/providers/DictionaryProvider.dart';
import 'package:bookbinding/providers/VocabProviders.dart';
// import 'package:bookbinding/utils/deepl.dart';
import 'package:provider/provider.dart';

class DictionaryEntryWidget extends StatefulWidget {
  final String word;
  final String context;

  const DictionaryEntryWidget({super.key, required this.word, required this.context});

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
    // final translation = await fetchTranslation(word, context);
    // final examples = await fetchExamples(word);
    final synonyms = await fetchSynonyms(word);
    
    var entries = await provider.entrys(word, 'sv-en');

    if (entries.isEmpty) {
      print('no entries');
      return {'word': '"$word" not found in dictionary','translation': '', 'examples': List<Example>.empty(), 'synonyms': [''], 'pos': '', 'pronunciation': ''};
    }
    
    return {
      'word': entries.first.entry.title,
      'translation': '',
      'examples': entries.first.entry.examples,
      'synonyms': synonyms,
      'pos': entries.first.entry.pos,
      'pronunciation': entries.first.entry.pronunciation,
    };
  }

  Future<String> fetchTranslation(String word, String context) async {
    // var response = await DeepL.translateText(
    //     text: word, sourceLang: 'fr', targetLang: 'en', context: context);
    var response = 'temp.';
    // if (response == null) {
    //   return 'Translation not found';
    // }
    return response;
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
          return const Center(child: Text('No dictionary entry available'));
        } else {
          final wordInfo = snapshot.data!;
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wordInfo['word'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    wordInfo['pos'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  wordInfo['translation'].isNotEmpty ? _buildSection('Translation', wordInfo['translation']) : const SizedBox.shrink(),
                  wordInfo['examples'].isNotEmpty ? _buildExamplesSection('Examples', wordInfo['examples']) : const SizedBox.shrink(),
                  // _buildListSection('Synonyms', wordInfo['synonyms']),
                  const SizedBox(height: 16),
                  wordInfo['word'] != '"${widget.word}" not found in dictionary' ? ElevatedButton.icon(
                    onPressed: () async {
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
                  ) : const SizedBox.shrink(),
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
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.value.example,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  Text(
                    item.value.translation,
                    style: TextStyle(color: Colors.grey[300]),
                    softWrap: true,
                  )
                ],
              )
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}
