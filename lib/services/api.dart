import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'models/article.dart';
import 'models/quote.dart';

class API {
  final String _apiUrl = 'http://dev.voodalab.com:8080';

  _quotes(String locale) {
    return '$_apiUrl/school/quotes/$locale?lastRequest=0';
  }

  _articles(String locale) {
    return '$_apiUrl/school/articles/$locale?lastRequest=0';
  }

   _basicAuth() {
    return 'Basic ' + base64Encode(utf8.encode('user:test'));
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

  Future fetchArticles(String locale) async {
    // final String basicAuth = 'Basic ' + base64Encode(utf8.encode('user:test'));
    final response = await http.get(Uri.parse(_articles(locale)), headers: {
      HttpHeaders.authorizationHeader: _basicAuth(),
    });
    log('Response: $response');

    if(response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles from API $response');
    }
  }

  Future fetchQuotes(String locale) async {
    // final String basicAuth = 'Basic ' + base64Encode(utf8.encode('user:test'));

    final response = await http.get(Uri.parse(_quotes(locale)), headers: {
      HttpHeaders.authorizationHeader: _basicAuth(),
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
