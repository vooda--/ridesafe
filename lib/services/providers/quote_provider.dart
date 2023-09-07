import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ride_safe/services/models/article.dart';

import '../api.dart';
import '../models/quote.dart';

class RideSafeProvider with ChangeNotifier {
  API apiService = API();
  List<Quote> _quotes = [];
  List<Article> _articles = [];

  selectedQuote(int index) {
    return _quotes[index];
  }

  List<Quote> get quotes => _quotes;
  List<Article> get articles => _articles;
  
  Future<void> fetchQuotes() async {
    return apiService.fetchQuotes('ru').then((quotes) {
      _quotes = quotes;
      log('Fetched quotes: ${_quotes.length}');
      notifyListeners();
    });
  }

  Future<void> fetchArticles() async {
    return apiService.fetchArticles('en').then((articles) {
      _articles = articles;
      log('Fetched articles: ${_articles.length}');
      notifyListeners();
    });
  }

  Future<void> fetchUsers() async {
    return apiService.fetchUsers().then((quotes) {
      _quotes = quotes;
      log('Users fetched: ${_quotes.length}');
      notifyListeners();
    });
  }
}