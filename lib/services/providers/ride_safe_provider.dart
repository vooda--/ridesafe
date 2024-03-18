import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_safe/services/hive_service.dart';
import 'package:ride_safe/services/models/article.dart';
import 'package:ride_safe/services/models/article_category.dart';
import 'package:ride_safe/services/models/quiz.dart';
import 'package:ride_safe/services/models/quiz_category.dart';

import '../api.dart';
import '../models/quote.dart';

class RideSafeProvider with ChangeNotifier {
  final API apiService;
  final HiveService hiveService;
  String filter = '';
  String articleFilter = '';

  RideSafeProvider(this.hiveService, this.apiService);

  selectedQuote(int index) {
    return quotes[index];
  }

  List<Quiz> get quizzes => hiveService.getQuizzesBox(filter);

  List<Quote> get quotes => hiveService.getQuotesBox(filter);

  List<Article> get articles => hiveService.getArticlesBox(articleFilter);

  List<Quote> get favoriteQuotes => hiveService.getFavoriteQuotes();

  List<QuizCategory> get quizCategories => hiveService.getQuizCategoriesBox();
  List<ArticleCategory> get articleCategories =>
      hiveService.getArticleCategoriesBox();

  int get lastFetchTime => hiveService.getFetchTime();

  void filterQuotes(String? filter) {
    this.filter = filter ?? '';
    notifyListeners();
  }
  void filterQuizes(String? filter) {
    this.filter = filter ?? '';
    notifyListeners();
  }
  void filterArticles(String? filter) {
    articleFilter = filter ?? '';
    notifyListeners();
  }

  Future<void> fetchAll() async {
    if (quotes.isNotEmpty) {
      await hiveService.saveFetchTime(true);
    }

    await fetchQuotes();
    await fetchQuizes();
    await fetchQuizCategories();
    await fetchArticles();
    await fetchArticleCategories();
    hiveService.saveFetchTime();
  }

  Future<void> openBoxes() async {
    await hiveService.openBox(HiveService.quotesKey);
    await hiveService.openBox(HiveService.quizCategoriesKey);
    await hiveService.openBox(HiveService.quizesKeys);
    await hiveService.openBox(HiveService.articlesKey);
    await hiveService.openBox(HiveService.articleCategoriesKey);
    await hiveService.openBox(HiveService.fetchedAt);
    await hiveService.openBox(HiveService.favoriteQuotesKey);
  }

  Future<void> fetchQuizes() async {
    return apiService.fetchQuizes('en', lastFetchTime).then((quizzes) {
      hiveService.setQuizzes(quizzes);
      log('Fetched quizzes: ${quizzes.length}');
      notifyListeners();
    });
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

  Future<void> fetchQuizCategories() async {
    return apiService.fetchQuizCategories('en').then((value) {
      if (value.length > 0) {
        hiveService.setQuizCategories(value);
      }

      log('Fetched quiz categories: ${quizCategories.length}');
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

  Future<Uint8List> loadImageAsUint8List(String imagePath) async {
    ByteData data = await rootBundle.load(imagePath);
    List<int> bytes = data.buffer.asUint8List();
    return Uint8List.fromList(bytes);
  }

  Future<Uint8List> getImage(BuildContext context, int id) {
    return apiService.imageById(id).then((value) {
      return value;
    });
  }

  Future<Uint8List> randomImage(BuildContext context) {
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return apiService.fetchRandomImage(isLandscape ? 'landscape' : 'portrait').then((value) {
      return value;
    });
  }

  Quote randomQuote() {
    if (quotes.isEmpty) {
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
