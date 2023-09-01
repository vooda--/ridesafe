import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'models/quote.dart';

class API {
  final String _apiUrl = 'http://dev.voodalab.com:8080';

  quotes(String locale) {
    return '$_apiUrl/school/quotes/$locale?lastRequest=0';
  }

  Future<List<Quote>> fetchUsers() async {
    final String baseUrl = 'https://jsonplaceholder.typicode.com';

    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => Quote.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users: $response.statusCode');
    }
  }

  Future fetchQuotes(String locale) async {
    final String basicAuth = 'Basic ' + base64Encode(utf8.encode('user:test'));

    final response = await http.get(Uri.parse(quotes(locale)), headers: {
      HttpHeaders.authorizationHeader: basicAuth,
    });
    log('Response: $response');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((quote) => Quote.fromJson(quote)).toList();
    } else {
      throw Exception('Failed to load quotes from API $response');
    }
  }
}
