import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ride_safe/services/models/prefetchedImage.dart';
import 'package:ride_safe/services/models/quiz_category.dart';
import 'package:ride_safe/services/models/quiz_progress.dart';
import 'package:ride_safe/services/models/token.dart';
import 'package:ride_safe/services/models/user.dart';

import 'models/article.dart';
import 'models/article_category.dart';
import 'models/quiz.dart';
import 'models/quote.dart';

class API {
  static String API_URL = 'https://dev.voodalab.com';

  _quotes(String locale, int lastTimeFetched) {
    return '$API_URL/school/quotes/$locale?lastRequest=$lastTimeFetched';
  }

  _quizes(String locale, int lastTimeFetched) {
    return '$API_URL/quiz/quizes/$locale?lastRequest=$lastTimeFetched';
  }

  _random(String orientation) {
    return '$API_URL/quotes/randomImage?keywords=girls&orientation=$orientation';
  }

  _randomN(String orientation, int quantity) {
    return '$API_URL/quotes/randomImages?keywords=girls&orientation=$orientation&quantity=$quantity';
  }

  _imageById(int id) {
    return '$API_URL/images/${id}';
  }

  _imageByName() {
    return '$API_URL/images/name';
  }

  _userData() {
    return '$API_URL/user/current';
  }

  _users() {
    return '$API_URL/user';
  }

  _quizProgress() {
    return '$API_URL/quiz-progress';
  }

  _login() {
    return '$API_URL/user/authenticate';
  }

  _articles(String locale, int lastTimeFetched) {
    return '$API_URL/school/articles/$locale?lastRequest=$lastTimeFetched';
  }

  _quizCategories(String locale) {
    return '$API_URL/quizCategory/categories/$locale';
  }

  _articleCategories(String locale) {
    return '$API_URL/school/articleCategories/$locale';
  }

  _basicAuth() {
    return 'Basic ${base64Encode(utf8.encode('user:@test#12'))}';
  }

  Future imageById(int id) async {
    http.Response response = await performGetRequest(url: _imageById(id));
    log('Response image: $response');

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image: $response.statusCode');
    }
  }

  Future imageByName(String name) async {
    final response = await http.post(Uri.parse(_imageByName()), body: {
      'name': name,
    }, headers: {
      HttpHeaders.authorizationHeader: _basicAuth(),
    });
    log('Response image: $response');

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image: $response.statusCode');
    }
  }

  Future fetchRandomImage(String orientation) async {
    http.Response response = await performGetRequest(url: _random(orientation));
    log('Response: $response');

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image: $response.statusCode');
    }
  }

  Future fetchRandomImages(String orientation, int number) async {
    http.Response response =
        await performGetRequest(url: _randomN(orientation, number));
    log('Response: $response');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (kDebugMode) {
        print(jsonResponse.length);
      }
      return jsonResponse
          .map((prefetchedImage) => PrefetchedImage.fromJson(prefetchedImage))
          .toList();
    } else {
      print(response);
      throw Exception('Failed to load images: $response');
    }
  }

  Future<http.Response> performPostRequest(
      String url, String payload, bool authHeader) async {
    http.Response response = http.Response('Error', 500);
    try {
      response = await http.post(Uri.parse(url),
          body: payload,
          headers: authHeader
              ? {
                  HttpHeaders.authorizationHeader: _basicAuth(),
                  HttpHeaders.contentTypeHeader: "application/json"
                }
              : {HttpHeaders.contentTypeHeader: "application/json"});
    } on SocketException catch (e) {
      // Handle other types of SocketException errors
      print('SocketException: $e');
      return Future(() => http.Response('Error', 500));
    }
    return response;
  }

  Future<http.Response> performGetRequest(
      {required String url, String? token}) async {
    http.Response response = http.Response('Error', 500);
    try {
      response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            (token != null) ? 'Bearer $token' : _basicAuth(),
      });
      print('$response');
    } on SocketException catch (e) {
      // Handle other types of SocketException errors
      print('SocketException: $e');
      return Future(() => http.Response('Error', 500));
    }
    return response;
  }

  Future<Token> login(String email, String password) async {
    http.Response response = await performPostRequest(
        _login(), jsonEncode({'email': email, 'password': password}), false);
    if (response.statusCode == 200) {
      Map<String, dynamic> tokenJson = json.decode(response.body);
      return Token.fromJson(tokenJson);
    } else {
      return Token(token: '');
      throw Exception('Failed to login: $response.statusCode');
    }
  }

  Future<User> fetchUser(String token) async {
    http.Response response =
        await performGetRequest(url: _userData(), token: token);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return User.fromJson(jsonResponse);
    } else {
      return User(
          email: 'test@test.com',
          firstName: '',
          id: -1,
          enabled: true,
          lastName: '',
          role: 'user');
      throw Exception('Failed to load user: $response.statusCode');
    }
  }

  Future fetchQuizCategories(String locale) async {
    http.Response response =
        await performGetRequest(url: _quizCategories(locale));

    log('Response: $response');
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((articleCategory) => QuizCategory.fromJson(articleCategory))
          .toList();
    } else {
      throw Exception('Failed to load quiz categories from API $response');
    }
  }

  Future fetchArticleCategories(String locale) async {
    http.Response response =
        await performGetRequest(url: _articleCategories(locale));
    log('Response: $response');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((articleCategory) => ArticleCategory.fromJson(articleCategory))
          .toList();
    } else {
      throw Exception('Failed to load article categories from API $response');
    }
  }

  Future updateQuizProgress(String? token, QuizProgress quiz) async {
    http.Response response = await performPostRequest(
        _quizProgress() + '/add',
        jsonEncode(quiz.toJson()),
        true);
    log('Response: $response');

    if (response.statusCode != 200) {
      throw Exception('Failed to update quiz progress from API $response');
    }
  }

  Future fetchUserQuizesProgress(String? token) async {
    http.Response response = await performGetRequest(
        url: _quizProgress() + '/user/quizes', token: token);
    log('Response: $response');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((quizProgress) => QuizProgress.fromJson(quizProgress))
          .toList();
    } else {
      throw Exception('Failed to load quiz progress from API $response');
    }
  }

  Future fetchQuizes(String locale, int lastTImeFetched) async {
    http.Response response =
        await performGetRequest(url: _quizes(locale, lastTImeFetched));
    log('Response: $response');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((quiz) => Quiz.fromJson(quiz)).toList();
    } else {
      throw Exception('Failed to load quizes from API $response');
    }
  }

  Future fetchArticles(String locale, int lastTimeFetched) async {
    http.Response response =
        await performGetRequest(url: _articles(locale, lastTimeFetched));
    log('Response: $response');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load articles from API $response');
    }
  }

  Future fetchQuotes(String locale, int lastTimeFetched) async {
    http.Response response =
        await performGetRequest(url: _quotes(locale, lastTimeFetched));
    log('Quote Response: $response');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      log('quotes: $jsonResponse.length');
      return jsonResponse.map((quote) => Quote.fromJson(quote)).toList();
    } else {
      throw Exception('Failed to load quotes from API $response');
    }
  }
}
