import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:langread/server/methods/books.dart';
import 'package:langread/server/models/user.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/foundation.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  late final PocketBase _pb;
  String? _authToken;
  User? get user => User(_pb.authStore.model);

  factory PocketBaseService() {
    return _instance;
  }

  PocketBaseService._internal() {
    _pb = PocketBase(dotenv.env['POCKETBASE_URL']!);
    // Initialize any other variables or settings here
  }

  Future<void> initialize() async {
    // Perform any initialization tasks here
    // For example, you might want to check for an existing auth token in secure storage
    // and authenticate the user automatically if it exists
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final user = await _pb.collection('users').create(body: {
        'email': email,
        'password': password,
        'passwordConfirm': password,
      });

      _authToken = user.data['token'];
      return true;
    } catch (e) {
      debugPrint('Error during sign up: $e');
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final user = await _pb.collection('users').authWithPassword(email, password);
      _authToken = user.token;
      return true;
    } catch (e) {
      debugPrint('Error during sign in: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    _pb.authStore.clear();
    _authToken = null;
  }

  BooksPocketbase get booksPb => BooksPocketbase(_pb);

  bool get isAuthenticated => _pb.authStore.isValid;

  String? get authToken => _authToken;
}