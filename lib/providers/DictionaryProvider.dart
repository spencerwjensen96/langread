import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter/widgets.dart';
import 'package:langread/server/methods/dictionaries.dart';
import 'package:langread/server/pocketbase.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart';

class DictionaryProvider {

  DictionariesPocketBase dictionaryService = PocketBaseService().dictionaries;

  Future<List<DictionaryEntryDB>> entrys(
      String word, String dictionary) async {
    
    var path = join((await getApplicationDocumentsDirectory()).path,
        'dictionaries',
        '$dictionary.db');
    if (!await File(path).exists()){
      await dictionaryService.fetchDictionary(dictionary, path);
    }
    print('opening db...');
    final db = await openDatabase(path);
    print('querying db...');
    final List<Map<String, Object?>> entryMaps = await db.query('definitions',
        columns: ['id', 'title', 'entry'],
        where: '"title" = ? and id LIKE ?',
        whereArgs: [word, '%$dictionary%']);
    await db.close();

    return [
      for (final {
            'id': id as String,
            'title': title as String,
            'entry': entry as List<int>,
          } in entryMaps)
        DictionaryEntryDB(
          id: id,
          title: title,
          entry: utf8.decode(entry),
        ),
    ];
  }
}

class DictionaryEntryDB {
  final String id;
  final String title;
  final String entry;

  const DictionaryEntryDB(
      {required this.id, required this.title, required this.entry});
}

class DictionaryEntry {
  final String title;
  final String pronunciation;
  final List<Definition> definitions;
  final List<Example> examples;

  DictionaryEntry({
    required this.title,
    required this.pronunciation,
    required this.definitions,
    required this.examples,
  });

  factory DictionaryEntry.fromXml(XmlNode xmlNode) {
    String? title = '';
    String? pronunciation = '';
    List<Example>? examples = [];
    try {
      title = xmlNode.getAttribute('d:title');
      pronunciation = xmlNode
          .findAllElements('span')
          .firstWhere((element) => element.getAttribute('d:prn') != null)
          .innerText;
      examples = xmlNode
          .findAllElements('span')
          .where((element) => element.getAttribute('class') == 'exg x_xd2 hasSn')
          .map((element) => Example.fromXml(element))
          .toList();
      // print(examples);
    } catch (e) {
      print(e);
    }

    return DictionaryEntry(
      title: title ?? '',
      pronunciation: pronunciation ?? 'None',
      definitions: [],
      // examples: [],
      examples: examples ?? [],
    );
  }
}

class Example {
  final String example;
  final String translation;

  Example({required this.example, required this.translation});
  factory Example.fromXml(XmlElement xml) {
    var ex = xml
        .findAllElements('span')
        .firstWhere((element) => element.getAttribute('class') == 'ex');
    // print("===");
    // print(xml);
    // print(ex);
    var trans = xml
        .findAllElements('span')
        .firstWhere((element) => element.getAttribute('class') == 'trans');
    // print(trans);
    // print("===");
    return Example(
        example: ex.innerText,
        translation: trans.innerText);
  }
}

class Definition {
  final String partOfSpeech;
  final List<String> translations;

  Definition({
    required this.partOfSpeech,
    required this.translations,
  });

  factory Definition.fromXml(XmlElement xml) {
    final partOfSpeech = xml
        .findElements('span')
        .firstWhere((element) => element.getAttribute('d:pos') != null)
        .text
        .trim();
    final translations = xml
        .findAllElements('span')
        .where((element) => element.getAttribute('class') == 'trans')
        .map((element) => element.text.trim())
        .toList();

    return Definition(
      partOfSpeech: partOfSpeech,
      translations: translations,
    );
  }
}
