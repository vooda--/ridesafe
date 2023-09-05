import 'dart:developer';

import 'package:flutter/material.dart';

import '../api.dart';
import '../models/quote.dart';

class QuoteProvider with ChangeNotifier {
  API apiService = API();
  List<Quote> _quotes = [];

  selectedQuote(int index) {
    return _quotes[index];
  }

  List<Quote> get quotes => _quotes;
  
  Future<void> fetchQuotes() async {
    return apiService.fetchQuotes('ru').then((quotes) {
      _quotes = quotes;
      log('Fetched quotes: ${_quotes.length}');
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