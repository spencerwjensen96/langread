import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DictionaryUtils {
  static final String _baseUrl = dotenv.env['OXFORD_DICTIONARY_BASE_URL']!;
  static final String _appId = dotenv.env['APP_ID']!;
  static final String _appKey = dotenv.env['APP_KEY']!;

  static Future<Map<String, dynamic>> fetchBilingualWordDefinition(String word, String sourceLanguage, String targetLanguage) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/translations/$sourceLanguage/$targetLanguage?q=$word'),
      headers: {
        'app_id': _appId,
        'app_key': _appKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load word definition');
    }
  }

  static Future<Map<String, dynamic>> fetchSynonyms(String word, String sourceLanguage) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/thesaurus/$sourceLanguage/$word'),
      headers: {
        'app_id': _appId,
        'app_key': _appKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load synonyms');
    }
  }
}