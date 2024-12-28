import 'dart:io';
import 'dart:async';
import 'dart:convert' show utf8;
import 'package:bookbinding/server/methods/dictionaries.dart';
import 'package:bookbinding/server/pocketbase.dart';
import 'package:flutter/material.dart';
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
    final db = await openDatabase(path);
    final List<Map<String, Object?>> entryMaps = await db.query('definitions',
        columns: ['id', 'title', 'entry'],
        where: '"title" LIKE ? and id LIKE ?',
        whereArgs: [word, '%$dictionary%']);
    await db.close();

    if (entryMaps.isEmpty) {
      return [];
    }

    return [
      for (final {
            'id': id as String,
            'title': title as String,
            'entry': entry as List<int>,
          } in entryMaps)
        DictionaryEntryDB(
          id: id,
          title: title,
          entry: DictionaryEntry.fromXml(XmlDocument.parse(utf8.decode(entry))),
        ),
    ];
  }
}

class DictionaryEntryDB {
  final String id;
  final String title;
  final DictionaryEntry entry;

  const DictionaryEntryDB(
      {required this.id, required this.title, required this.entry});
  
  @override
  String toString() {
    return 'DictionaryEntryDB(id: $id, title: $title, entry: $entry)';
  }
}

class DictionaryEntry {
  final String title;
  final String pos;
  final String pronunciation;
  final List<Definition> definitions;
  final List<Example> examples;

  DictionaryEntry({
    required this.title,
    required this.pos,
    required this.pronunciation,
    required this.definitions,
    required this.examples,
  });

  factory DictionaryEntry.fromXml(XmlNode xmlNode) {
    List<XmlElement>? entries = [];
    String? title = '';
    String? pronunciation = '';
    String? pos = '';
    List<Example> examples = [];
    try {
      entries = xmlNode.findElements('d:entry').toList();
      title = entries.first.getAttribute('d:title');
      print(title);
      print(xmlNode.toXmlString(pretty: true));
      pos = entries.first.findAllElements('d:pos').first.parent?.innerText;

      // pronunciation = xmlNode
      //     .findAllElements('span')
      //     .firstWhere((element) => element.getAttribute('d:prn') != null)
      //     .innerText;
      
      var _examples = xmlNode
        .findAllElements('span')
        .firstWhere((element) => element.getAttribute('class')?.startsWith('semb') ?? false)
        .findAllElements('span')
        .where((element) => element.getAttribute('class')?.startsWith('exg') ?? false);      
      print(_examples);
      _examples.forEach((element) => examples.add(Example.fromXml(element)));
      
    } catch (e) {
      print(e);
    }

    return DictionaryEntry(
      title: title ?? '',
      pos: pos ?? '',
      pronunciation: pronunciation,
      definitions: [],
      examples: examples,
    );
  }

  @override
  String toString() {
    return 'DictionaryEntry(title: $title, pos: $pos, pronunciation: $pronunciation, definitions: $definitions, examples: $examples)';
  }
}

class Example {
  final String example;
  final String translation;

  Example({required this.example, required this.translation});
  factory Example.fromXml(XmlElement xml) {
    var ex = xml
      .findElements('span')  
      .firstWhere((element) => element.getAttribute('class') == 'x_xdh')
      .findElements('span')    
      .firstWhere((element) => element.getAttribute('class') == 'ex').innerText;

    var trans = xml
      .findElements('span')
      .firstWhere((element) => element.getAttribute('class') == 'trg x_xd3')
      .findElements('span')
      .firstWhere((element) => element.getAttribute('class') == 'trans').innerText;

    return Example(
        example: ex,
        translation: trans);
  }

  @override
  String toString() {
    return 'Example(example: $example, translation: $translation)';
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
