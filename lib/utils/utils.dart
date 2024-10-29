bool listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

Map<String, String> parseCustomTags(String html) {
  final RegExp tagPattern = RegExp(r'<(\w+)>(.*?)<\/\1>', dotAll: true);

  final Map<String, String> tagContentMap = {};

  Iterable<RegExpMatch> matches = tagPattern.allMatches(html);

  for (var match in matches) {
    String tag = match.group(1)!; // Group 1 is the tag name
    String content = match.group(2)!; // Group 2 is the content inside the tag
    tagContentMap[tag] = content;
  }

  return tagContentMap;
}

extension StringCasingExtension on String {
  String get toCapitalized => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized).join(' ');
}