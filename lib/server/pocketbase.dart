import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bookbinding/server/methods/auth.dart';
import 'package:bookbinding/server/methods/books.dart';
import 'package:bookbinding/server/methods/dictionaries.dart';
import 'package:bookbinding/server/models/user.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  late final PocketBase _pb;

  // late final SharedPreferencesWithCache prefs;

  User? get user => User(_pb.authStore.model);
  bool get isAuthenticated => _pb.authStore.isValid;
  String? get authToken => auth.authToken;

  factory PocketBaseService() {
    return _instance;
  }

  PocketBaseService._internal();

  void initialize(SharedPreferencesWithCache prefsWithCache) {
    // Perform any initialization tasks here
    // For example, you might want to check for an existing auth token in secure storage
    // and authenticate the user automatically if it exists
    final store = AsyncAuthStore(
      save: (String data) async => prefsWithCache.setString('pb_auth', data),
      initial: prefsWithCache.getString('pb_auth'),
    );

    if (store.model == null) {
      _pb = PocketBase(dotenv.env['POCKETBASE_URL']!);
    }
    else{
      _pb = PocketBase(dotenv.env['POCKETBASE_URL']!, authStore: store);
      _pb.collection('users').authRefresh();
    }
    _pb.authStore.onChange.listen((e) {
      final encoded = jsonEncode(<String, dynamic>{
        "token": e.token,
        "model": e.model,
      });
      prefsWithCache.setString("pb_auth", encoded);
    });
  }

  BooksPocketbase get books => BooksPocketbase(_pb);

  AuthPocketbase get auth => AuthPocketbase(_pb);

  DictionariesPocketBase get dictionaries => DictionariesPocketBase(_pb);
}
