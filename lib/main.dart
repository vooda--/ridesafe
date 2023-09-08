import 'package:flutter/material.dart';
import 'package:ride_safe/features/quotes/quotes.dart';
import 'package:ride_safe/features/school/school.dart';
import 'package:ride_safe/services/models/app_state_model.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';

import 'features/about/about.dart';
import 'features/main_page.dart';
import 'features/quizzes/quiz.dart';
import 'features/quotes/quote.dart';

void main() {
  runApp(MultiProvider(
  providers: [
        ChangeNotifierProvider(create: (context) => AppStateModel()),
        ChangeNotifierProvider(create: (context) => RideSafeProvider()),
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
        '/quote': (context) => QuotesPage(),
        '/quote/selected': (context) => QuotePage(), // '/quote/selected
        '/quiz': (context) => QuizPage(),
        '/school': (context) => SchoolPage(),
        '/about': (context) => AboutPage(),
      },
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF0A0E21),
          primaryColor: Color(0xFF0A0E21)),
    );
  }
}


