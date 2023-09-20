import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ride_safe/services/hive_service.dart';
import 'package:ride_safe/services/models/article.dart';
import 'package:ride_safe/services/models/article_category.dart';

import '../api.dart';
import '../models/quote.dart';

class RideSafeProvider with ChangeNotifier {
  final API apiService;
  final HiveService hiveService;

  RideSafeProvider(this.hiveService, this.apiService);

  selectedQuote(int index) {
    return quotes?[index];
  }

  List<Quote> get quotes => hiveService.getQuotesBox();

  List<Article> get articles => hiveService.getArticlesBox();

  List<Quote> get favoriteQuotes => hiveService.getFavoriteQuotes();

  List<ArticleCategory> get articleCategories =>
      hiveService.getArticleCategoriesBox();

  int get lastFetchTime => hiveService.getFetchTime();

  Future<void> fetchAll() async {
    if (quotes.isNotEmpty) {
      await hiveService.saveFetchTime(true);
    }

    await fetchQuotes();
    await fetchArticles();
    await fetchArticleCategories();
    hiveService.saveFetchTime();
  }

  Future<void> openBoxes() async {
    await hiveService.openBox(HiveService.quotesKey);
    await hiveService.openBox(HiveService.articlesKey);
    await hiveService.openBox(HiveService.articleCategoriesKey);
    await hiveService.openBox(HiveService.fetchedAt);
    await hiveService.openBox(HiveService.favoriteQuotesKey);
  }

  Future<void> fetchQuotes() async {
    return apiService.fetchQuotes('ru', lastFetchTime).then((quotes) {
      if (quotes.length > 0) {
        hiveService.setQuotes([...this.quotes, ...quotes]);
      }
      log('Fetched quotes: ${quotes.length}');
      notifyListeners();
    });
  }

  Future<void> fetchArticleCategories() async {
    return apiService.fetchArticleCategories('en').then((value) {
      if (value.length > 0) {
        hiveService.setArticleCategories(value);
      }

      log('Fetched article categories: ${articleCategories.length}');
      notifyListeners();
    });
  }

  Future<Uint8List> randomImage(BuildContext context) {
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return apiService.fetchRandomImage(isLandscape ? 'landscape' : 'portrait').then((value) {
      return value;
    });
  }

  Quote randomQuote() {
    if (quotes == null || quotes!.isEmpty) {
      return Quote(
          draft: false,
          hidden: false,
          id: 0,
          quoteText: 'No Quotes yet',
          author: 'RideSafe');
    }
    final index = DateTime.now().millisecondsSinceEpoch % quotes.length;
    return quotes[index];
  }

  Future<void> fetchArticles() async {
    return apiService.fetchArticles('en', lastFetchTime).then((articles) {
      hiveService.setArticles(articles);
      log('Fetched articles: ${articles.length}');
      notifyListeners();
    });
  }

  /*
  @deprecated: remove this method
   */
  Future<void> fetchUsers() async {
    return apiService.fetchUsers().then((quotes) {
      // _quotes = quotes;
      log('Users fetched: ${quotes.length}');
      notifyListeners();
    });
  }
}
class ScreenshotEvent {}
