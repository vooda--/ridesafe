import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ride_safe/services/hive_service.dart';
import 'package:ride_safe/services/models/article.dart';
import 'package:ride_safe/services/models/article_category.dart';
import 'package:ride_safe/services/models/image.dart' as IMAGE;
import 'package:ride_safe/services/models/quiz.dart';
import 'package:ride_safe/services/models/quiz_category.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../api.dart';
import '../models/quote.dart';

class RideSafeProvider with ChangeNotifier {
  final API apiService;
  final HiveService hiveService;

  String filter = '';
  String articleFilter = '';

  RideSafeProvider(this.hiveService, this.apiService);

  selectedQuote(int index) {
    return quotes.elementAt(index);
  }

  // Future<String> get _localPath async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }

  List<Quiz> get quizzes => hiveService.getQuizzes(filter);

  Iterable<Quote> get quotes => hiveService.getQuotesBox(filter);

  Box<IMAGE.Image> get images => hiveService.getImagesBox();

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
    await hiveService.initialize();
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
        hiveService.addQuotes(quotes);
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

  void saveFile(Uint8List imageData, int id) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      var path = directory.path;
      File file = File("$path/${id}.jpg");
      await file.writeAsBytes(imageData);
      log("File is written to: , ${file.path}");
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List> _getFile(int? id) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      var path = directory.path;
      File file = File("$path/${id}.jpg");
      return file.readAsBytes();
    } catch (e) {
      print(e);
      return Future(() => Uint8List.fromList([]));
    }
  }

  Future<Uint8List> getImage(BuildContext context, int? id) {
    if (id == null) {
      return Future(() => Uint8List.fromList([])); // Empty image data
    }
    IMAGE.Image? image =
        images.values.where((element) => element.id == id).firstOrNull;
    if (image != null && !kIsWeb) {
      log('Have found ${id} image in the box!');
      return _getFile(id);
    }
    log('Image ${id} not found in the box!');
    return apiService.imageById(id).then((value) {
      hiveService.setImage(IMAGE.Image(id: id, name: id.toString()));
      saveFile(value, id);
      return value;
    });
  }

  Future<Uint8List> randomImage(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return apiService
        .fetchRandomImage(isLandscape ? 'landscape' : 'portrait')
        .then((value) {
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
    return quotes.elementAt(index);
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
