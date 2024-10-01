

import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthPocketbase {
  late final PocketBase _pb;
  String? _authToken;

  AuthPocketbase(PocketBase pb) {
    _pb = pb;
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

  String? get authToken => _authToken;
}