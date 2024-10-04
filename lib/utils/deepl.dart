import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DeepL {

  static final String baseUrl = dotenv.env['DEEPL_BASE_URL']!;
  static final String apiKey = dotenv.env['DEEPL_API_KEY']!;

  DeepL();

  static Future<String?> translateText({
    required String text,
    required String sourceLang,
    required String targetLang,
    required String context,
  }) async {
    // Define the API URL
    final uri = Uri.parse('$baseUrl/translate');

    // Create the request body
    final body = {
      'text': text,
      'source_lang': sourceLang,
      'target_lang': targetLang,
      'formality': "prefer_more",
      'context': context,
    };

    // Make the POST request
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'DeepL-Auth-Key $apiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      // Check for successful response
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final translations = responseData['translations'];
        return translations[0]['text'];
      } else {
        print('Error: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }

}