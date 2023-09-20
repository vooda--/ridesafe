import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ride_safe/features/quotes/quotes.dart';
import 'package:ride_safe/features/school/articles.dart';
import 'package:ride_safe/services/api.dart';
import 'package:ride_safe/services/hive_service.dart';
import 'package:ride_safe/services/models/app_state_model.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/models/article.dart';
import 'package:ride_safe/services/models/article_category.dart';
import 'package:ride_safe/services/models/quote.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';
import 'package:ride_safe/services/providers/screenshot_provider.dart';

import 'features/about/about.dart';
import 'features/main_page.dart';
import 'features/quizzes/quiz.dart';
import 'features/quotes/quote.dart';
import 'features/school/article.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(QuoteAdapter());
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(ArticleCategoryAdapter());
  var rideSafeProvider = RideSafeProvider(HiveService(), API());

  await rideSafeProvider.openBoxes();
  await rideSafeProvider.fetchAll();

  runApp(MultiProvider(
  providers: [
        ChangeNotifierProvider(create: (context) => AppStateModel()),
        ChangeNotifierProvider(create: (context) => ScreenshotProvider()),
        ChangeNotifierProvider(create: (context) => rideSafeProvider),
      ],
      child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/quote': (context) => QuotesPage(quoteType: QuoteType.all), // '/quote
        '/quote/selected': (context) => QuotePage(), // '/quote/selected
        '/favorites': (context) => const QuotesPage(quoteType: QuoteType.favorite), // '/favorites
        '/favorites/selected': (context) => QuotePage(), // '/favorites/selected
        '/quiz': (context) => QuizPage(),
        '/school': (context) => SchoolPage(),
        '/school/article': (context) => ArticlePage(),
        '/about': (context) => AboutPage(),
      },
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF0A0E21),
          primaryColor: Color(0xFF0A0E21)),
    );
  }
}


