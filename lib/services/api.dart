import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'models/article.dart';
import 'models/article_category.dart';
import 'models/quote.dart';

class API {
  final String _apiUrl = 'https://dev.voodalab.com';

  _quotes(String locale, int lastTimeFetched) {
    return '$_apiUrl/school/quotes/$locale?lastRequest=$lastTimeFetched';
  }

  _articles(String locale, int lastTimeFetched) {
    return '$_apiUrl/school/articles/$locale?lastRequest=$lastTimeFetched';
  }

  _articleCategories(String locale) {
    return '$_apiUrl/school/articleCategories/$locale';
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

  Future fetchArticleCategories(String locale) async {
    final response = await http.get(Uri.parse(_articleCategories(locale)), headers: {
      HttpHeaders.authorizationHeader: _basicAuth(),
    });
    log('Response: $response');
    if(response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((articleCategory) => ArticleCategory.fromJson(articleCategory)).toList();
    } else {
      throw Exception('Failed to load article categories from API $response');
    }
  }

  Future fetchArticles(String locale, int lastTimeFetched) async {
    // final String basicAuth = 'Basic ' + base64Encode(utf8.encode('user:test'));
    final response = await http.get(Uri.parse(_articles(locale, lastTimeFetched)), headers: {
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

  Future fetchQuotes(String locale, int lastTimeFetched) async {
    // final String basicAuth = 'Basic ' + base64Encode(utf8.encode('user:test'));

    final response = await http.get(Uri.parse(_quotes(locale, lastTimeFetched)), headers: {
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
