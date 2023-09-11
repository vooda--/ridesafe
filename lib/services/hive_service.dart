
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ride_safe/services/models/article.dart';
import 'package:ride_safe/services/models/article_category.dart';

import 'models/quote.dart';

class HiveService {
  static const String quotesKey = 'quotes';
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

  Future<void> setQuotes(List<Quote> quotes) async {
    await Hive.box(quotesKey).put('quotes', quotes);
  }

  Future<void> saveFetchTime([bool? reset]) async {
    var time = (reset == true) ? 0 : DateTime.now().millisecondsSinceEpoch;
    await Hive.box(fetchedAt).put(fetchedAt, time);
  }

  Future<void> setArticleCategories(List<ArticleCategory> articleCategories) async {
    await Hive.box(articleCategoriesKey).put('articleCategories', articleCategories);
  }

  Future<void> setArticles(List<Article> articles) async {
    await Hive.box(articlesKey).put('articles', articles);
  }

  int getFetchTime() {
    return Hive.box(fetchedAt).get(fetchedAt) ?? 0;
  }

  List<Quote> getQuotesBox() {
    var quotes = Hive.box(quotesKey).get('quotes') ?? [];
    return (quotes.cast<Quote>());
  }

  List<Article> getArticlesBox() {
    return Hive.box(articlesKey).get('articles') ?? [];
  }

  List<ArticleCategory> getArticleCategoriesBox() {
    return Hive.box(articleCategoriesKey).get('articleCategories') ?? [];
  }
}