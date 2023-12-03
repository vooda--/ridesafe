import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ride_safe/features/bottom_menu/bottom_mixin/bottom_mixin.dart';
import 'package:ride_safe/features/quizzes/quiz_result.dart';
import 'package:ride_safe/features/quizzes/quizes.dart';
import 'package:ride_safe/features/quotes/quotes.dart';
import 'package:ride_safe/features/school/articles.dart';
import 'package:ride_safe/my_colors.dart';
import 'package:ride_safe/services/api.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/helpers.dart';
import 'package:ride_safe/services/hive_service.dart';
import 'package:ride_safe/services/models/app_state_model.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/models/article.dart';
import 'package:ride_safe/services/models/article_category.dart';
import 'package:ride_safe/services/models/question.dart';
import 'package:ride_safe/services/models/quiz.dart';
import 'package:ride_safe/services/models/quiz_category.dart';
import 'package:ride_safe/services/models/quote.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';
import 'package:ride_safe/services/providers/screenshot_provider.dart';

import 'color_schemes.g.dart';
import 'features/about/about.dart';
import 'features/main_page.dart';
import 'features/quizzes/quiz.dart';
import 'features/quotes/quote.dart';
import 'features/school/article.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(QuoteAdapter());
  Hive.registerAdapter(QuizCategoryAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(QuizAdapter());
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(ArticleCategoryAdapter());
  var rideSafeProvider = RideSafeProvider(HiveService(), API());

  await rideSafeProvider.openBoxes();
  await rideSafeProvider.fetchAll();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateModel()),
        ChangeNotifierProvider(create: (context) => ScreenshotProvider()),
        ChangeNotifierProvider(create: (context) => BottomMenuLogic()),
        ChangeNotifierProvider(create: (context) => rideSafeProvider),
      ],
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/quote': (context) => const QuotesPage(quoteType: QuoteType.all),
        // '/quote
        '/quote/selected': (context) => const QuotePage(),
        // '/quote/selected
        '/favorites': (context) =>
        const QuotesPage(quoteType: QuoteType.favorite),
        // '/favorites
        '/favorites/selected': (context) => const QuotePage(),
        // '/favorites/selected
        '/quizes': (context) => const QuizesPage(),
        '/quizes/quiz': (context) => const QuizPage(),
        '/quizes/quiz/result': (context) => const QuizResultPage(),
        '/school': (context) => const SchoolPage(),
        '/school/article': (context) => const ArticlePage(),
        '/about': (context) => const AboutPage(),
      },
      // darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),

      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: MaterialColorGenerator.from(Colors.white),
        // extensions: <ThemeExtension<dynamic>>[
        //   const MyColors(grayBorderColor: AppColors.buttonBorderColor,
        //       lightBlueBg: AppColors.lightBlueColor,
        //       blackTextColor: AppColors.primaryTextColor,
        //       grayTextColor: AppColors.grayTextColor,
        //       whiteTextColor: AppColors.whiteColor,
        //       blueBg: AppColors.primaryColor,
        //       successBg: AppColors.successColor,
        //       dangerBg: AppColors.dangerColor)
        // ])
        // colorScheme: ColorScheme.light(
        //   primary: MaterialColorGenerator.from(AppColors.primaryColor),
        //   secondary: MaterialColorGenerator.from(AppColors.secondaryColor),
        //   error: MaterialColorGenerator.from(AppColors.dangerColor),
        //   tertiary: MaterialColorGenerator.from(AppColors.accentColor),
        //   brightness: Brightness.light,
        // )
      //   // primaryColorDark: const Color(AppColors.primaryColorDark),
      //   // primaryColorLight: const Color(AppColors.primaryColorLight),
      )
    );
  }
}


