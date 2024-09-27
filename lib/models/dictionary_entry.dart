class DictionaryEntryModel {
  final String word;

  DictionaryEntryModel(this.word);

  Future<Map<String, dynamic>> fetchWordInfo() async {
    final translation = await fetchTranslation();
    final definition = await fetchDefinition();
    final examples = await fetchExamples();
    final synonyms = await fetchSynonyms();

    return {
      'translation': translation,
      'definition': definition,
      'examples': examples,
      'synonyms': synonyms,
    };
  }

  Future<String> fetchTranslation() async {
    return 'TODO: Implement translations';
  }

  Future<String> fetchDefinition() async {
    return 'TODO: Implement definitions';
  }

  Future<List<String>> fetchExamples() async {
    return ['TODO: Implement examples', 'Example 1 with $word', 'Example 2 with $word'];
  }

  Future<List<String>> fetchSynonyms() async {
    return ['TODO: Implement synonyms', 'Synonym 1', 'Synonym 2'];
  }
}