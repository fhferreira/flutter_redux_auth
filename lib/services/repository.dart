import 'dart:async';
import 'dart:core';

import 'web_client.dart';

class Repository {
  final WebClient client;

  const Repository({this.client = const WebClient()});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final Map<String, String> credentials = {
      'email': email,
      'password': password,
    };
    return await client.post('/login', credentials);
  }

  Future<Map<String, dynamic>> me(String token) async {
    return await client.getAuth('/host/me', token);
  }
}