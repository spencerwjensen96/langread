class VocabularyItemModel {
  final String word;
  final String translation;
  final String sentence;
  final DateTime dateAdded;

  VocabularyItemModel({
    required this.word,
    required this.translation,
    required this.sentence,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'translation': translation,
      'sentence': sentence,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory VocabularyItemModel.fromMap(Map<String, dynamic> map) {
    return VocabularyItemModel(
      word: map['word'],
      translation: map['translation'],
      sentence: map['sentence'],
      dateAdded: DateTime.parse(map['dateAdded']),
    );
  }
}