
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

class DictionariesPocketBase {
  late final PocketBase _pb;

  DictionariesPocketBase(PocketBase pb) {
    _pb = pb;
  }

  Future<void> fetchDictionary(String dictionaryId, String path) async {
    var file = File(path);
    if (!await file.exists()) {
      try {
        final pb_response = await _pb
            .collection('dictionaries')
            .getFirstListItem('name="$dictionaryId"');
        var url = _pb.files.getUrl(pb_response, pb_response.data['dictionary_file'], query: {'download': true});
        final httpClient = HttpClient();
        final request = await httpClient.getUrl(url);
        final http_response = await request.close();
        final bytes = await consolidateHttpClientResponseBytes(http_response);
        await file.create(recursive: true);
        await file.writeAsBytes(bytes);
      } catch (e) {
        throw Exception('Error fetching books: $e');
      }
    }
  }

}