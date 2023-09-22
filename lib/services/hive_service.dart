import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ride_safe/services/models/article.dart';
import 'package:ride_safe/services/models/article_category.dart';

import 'models/quote.dart';

class HiveService {
  static const String quotesKey = 'quotes';
  static const String favoriteQuotesKey = 'favoriteQuotes';
  static const String favoriteImageKey = 'favoriteImage';
  static const String articlesKey = 'articles';
  static const String articleCategoriesKey = 'articleCategories';
  static const String fetchedAt = 'fetchedAt';

  HiveService();

  destroy() {
    Hive.close();
  }

  Future<void> openBox(String boxName) async {
    await Hive.openBox(boxName);
  }

  Future<void> closeBox(String boxName) async {
    await Hive.box(boxName).close();
  }

  List<Quote> getFavoriteQuotes() {
    var quotes = Hive.box(favoriteQuotesKey).get('quotes') ??
        List<Quote>.empty(growable: true);
    return (quotes.cast<Quote>());
  }

  Future<void> addFavoriteQuote(
      Quote quote, Future<Uint8List> imageFuture) async {
    List value = getFavoriteQuotes();
    quote.imageBytes = await imageFuture;
    value.add(quote);
    await Hive.box(favoriteQuotesKey).put('quotes', value);
  }

  Future<void> setQuotes(List<Quote> quotes) async {
    await Hive.box(quotesKey).put('quotes', quotes);
  }

  Future<void> saveFetchTime([bool? reset]) async {
    var time = (reset == true) ? 0 : DateTime.now().millisecondsSinceEpoch;
    await Hive.box(fetchedAt).put(fetchedAt, time);
  }

  Future<void> setArticleCategories(
      List<ArticleCategory> articleCategories) async {
    await Hive.box(articleCategoriesKey)
        .put('articleCategories', articleCategories);
  }

  Future<void> setArticles(List<Article> articles) async {
    await Hive.box(articlesKey).put('articles', articles);
  }

  int getFetchTime() {
    return Hive.box(fetchedAt).get(fetchedAt) ?? 0;
  }

  List<Quote> getQuotesBox(String? filter) {
    List<dynamic> quotes =
        Hive.box(quotesKey).get('quotes') ?? List.empty(growable: true);
    if (filter != null && filter.isNotEmpty) {
      quotes = quotes
          .where((quote) =>
              quote.quoteText.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
    log('Quotes: ${quotes.length}');
    return (quotes.cast<Quote>());
  }

  List<Article> getArticlesBox(String? filter) {
    List<dynamic> articles =
        Hive.box(articlesKey).get('articles') ?? List.empty(growable: true);

    if (filter != null && filter.isNotEmpty) {
      articles = articles
          .where((article) =>
              article.title.toLowerCase().contains(filter.toLowerCase()) ||
              article.description
                  .toLowerCase()
                  .contains(filter.toLowerCase()) ||
              article.content.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
    return (articles.cast<Article>());
  }

  List<ArticleCategory> getArticleCategoriesBox() {
    return Hive.box(articleCategoriesKey).get('articleCategories') ?? [];
  }
}
