import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

class WebClient {
  static String baseUrl = 'http://homestaymatch.homestead/api';

  const WebClient();

  Future<dynamic> get(String path) async {
    print('get $baseUrl$path');
    final http.Response response = await http.Client().get('$baseUrl$path');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An error occured: ' + response.body);
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    print('post $baseUrl$path');
    final http.Response response = await http.Client().post(
      '$baseUrl$path',
      body: data,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An error occured: ' + response.body);
    }
  }

  Future<dynamic> postAuth(String path, String token, Map<String, dynamic> data) async {
    print('postAuth $baseUrl$path');
    print('token $token');
    final http.Response response = await http.Client().post(
      '$baseUrl$path',
      headers: {
        'Authorization': 'Bearer ' + token
      },
      body: data,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An error occured: ' + response.body);
    }
  }

  Future<dynamic> getAuth(String path, String token) async {
    print('getAuth $baseUrl$path');
    print('token $token');
    final http.Response response = await http.Client().get(
      '$baseUrl$path',
      headers: {
        'Authorization': 'Bearer ' + token
      }
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('An error occured: ' + response.body);
    }
  }

}