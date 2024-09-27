import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/vocabulary_item.dart';

class VocabularyProvider with ChangeNotifier {
  List<VocabularyItemModel> _items = [];
  List<VocabularyItemModel> get items => _items;

  VocabularyProvider() {
    _loadItems();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/vocabulary_items.json');
  }

  Future<void> _loadItems() async {
    final file = await _localFile;
    try {
      if (!await file.exists()) {
        await file.create();
      }
      else {
        final String contents = await file.readAsString();
        final List<dynamic> decodedItems = json.decode(contents);
        _items = decodedItems.map((item) => VocabularyItemModel.fromMap(item)).toList();
      }
    } catch (e) {
      print('Error loading vocabulary items: $e');
    }
    notifyListeners();
  }

  Future<void> _saveItems() async {
    try {
      final file = await _localFile;
      final String itemsJson = json.encode(_items.map((item) => item.toMap()).toList());
      print(itemsJson);
      await file.writeAsString(itemsJson);
    } catch (e) {
      print('Error saving vocabulary items: $e');
    }
  }

  Future<void> addItem(VocabularyItemModel item) async {
    _items.add(item);
    await _saveItems();
    notifyListeners();
  }

  Future<void> removeItem(VocabularyItemModel item) async {
    _items.remove(item);
    await _saveItems();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _items.clear();
    await _saveItems();
    notifyListeners();
  }
}