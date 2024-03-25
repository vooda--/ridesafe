import 'dart:developer';
import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ride_safe/services/models/article.dart';
import 'package:ride_safe/services/models/article_category.dart';
import 'package:ride_safe/services/models/quiz.dart';
import 'package:ride_safe/services/models/quiz_category.dart';

import 'models/image.dart';
import 'models/quote.dart';

class HiveService {
  static const String quizCategoriesKey = 'quizCategories';
  static const String quizesKeys = 'quizzes';
  static const String quotesKey = 'quotes';
  static const String imagesKey = 'images';
  static const String favoriteQuotesKey = 'favoriteQuotes';
  static const String favoriteImageKey = 'favoriteImage';
  static const String articlesKey = 'articles';
  static const String articleCategoriesKey = 'articleCategories';
  static const String fetchedAt = 'fetchedAt';
  late Box quotesBox;
  late Box imagesBox;
  late Box quizCategoriesBox;
  late Box quizzesBox;
  late Box articlesBox;
  late Box articleCategoriesBox;
  late Box favoriteBox;
  late Box userDataBox;

  HiveService();

  Future<void> initialize() async {
    quotesBox = await Hive.openBox<Quote>(HiveService.quotesKey);
    imagesBox = await Hive.openBox<Image>(HiveService.imagesKey);
    quizCategoriesBox =
        await Hive.openBox<QuizCategory>(HiveService.quizCategoriesKey);
    quizzesBox = await Hive.openBox(HiveService.quizesKeys);
    articlesBox = await Hive.openBox(HiveService.articlesKey);
    articleCategoriesBox = await Hive.openBox(HiveService.articleCategoriesKey);
    userDataBox = await Hive.openBox(HiveService.fetchedAt);
    favoriteBox = await Hive.openBox(HiveService.favoriteQuotesKey);
  }

  destroy() {
    Hive.close();
  }

  // Future<Box> openBox<T>(String boxName) {
  //   return Hive.openBox(boxName);
  // }

  Future<void> closeBox(String boxName) async {
    await Hive.box(boxName).close();
  }

  List<Quote> getFavoriteQuotes() {
    var quotes = quotesBox.values.toList();
    return (quotes.cast<Quote>());
  }

  Future<void> addFavoriteQuote(
      Quote quote, Future<Uint8List> imageFuture) async {
    List value = getFavoriteQuotes();
    quote.imageBytes = await imageFuture;
    value.add(quote);
    await Hive.box(favoriteQuotesKey).put('quotes', value);
  }

  Future<void> setQuizzes(List<Quiz> quizes) async {
    await quizzesBox.addAll(quizes);
  }

  Future<void> addQuotes(List<Quote> quotes) async {
    await quotesBox.addAll(quotes);
  }

  Future<void> saveFetchTime([bool? reset]) async {
    var time = (reset == true) ? 0 : DateTime.now().millisecondsSinceEpoch;
    await userDataBox.put(fetchedAt, time);
  }

  Future<void> setQuizCategories(List<QuizCategory> quizCategories) async {
    await quizCategoriesBox.addAll(quizCategories);
  }

  Future<void> setArticleCategories(
      List<ArticleCategory> articleCategories) async {
    await articleCategoriesBox.addAll(articleCategories);
  }

  Future<void> setArticles(List<Article> articles) async {
    await articlesBox.addAll(articles);
  }

  Future<void> setImage(Image image) async {
    imagesBox.add(image);
    image.save(); //TODO: Do I need this really?
  }

  int getFetchTime() {
    log('LAast time fetched: ');
    var lastTime = userDataBox.get(fetchedAt);
    if (lastTime != Null) {
      log(lastTime.toString());
    } else {
      log('null last time');
    }
    return lastTime ?? 0;
  }

  Iterable<Quote> getQuotesBox(String? filter) {
    List<dynamic> quotes = quotesBox.values.toList();
    if (filter != null && filter.isNotEmpty) {
      quotes = quotes
          .where((quote) =>
              quote.quoteText.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
    log('Quotes: ${quotes.length}');
    return (quotes.cast<Quote>());
  }

  getImagesBox() {
    return imagesBox;
  }

  List<Article> getArticlesBox(String? filter) {
    List<dynamic> articles = articlesBox.values.toList();

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
    return articleCategoriesBox.values.toList().cast<ArticleCategory>();
  }

  List<Quiz> getQuizzes(String? filter) {
    List<dynamic> quizzes = quizzesBox.values.toList();
    if (filter != null && filter.isNotEmpty) {
      quizzes = quizzes
          .where((quiz) =>
              quiz.title.toLowerCase().contains(filter.toLowerCase()) ||
              quiz.description.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
    return (quizzes.cast<Quiz>());
  }

  List<QuizCategory> getQuizCategoriesBox() {
    return quizCategoriesBox.values.toList().cast<QuizCategory>();
  }
}
