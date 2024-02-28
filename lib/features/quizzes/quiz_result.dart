import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/helpers.dart';
import 'package:ride_safe/services/quiz_engine.dart';

import '../../services/providers/ride_safe_provider.dart';
import '../bottom_menu/bottom_menu.dart';
import '../drawer/my_drawer.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({super.key});

  @override
  State<QuizResultPage> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResultPage> {
  @override
  void initState() {
    super.initState();
    // Provider.of<RideSafeProvider>(context, listen: false).fetchArticles();
    // Provider.of<RideSafeProvider>(context, listen: false)
    //     .fetchArticleCategories();
  }

  @override
  Widget build(BuildContext context) {
    var quizEngine = ModalRoute.of(context)!.settings.arguments as QuizEngine;
    var controller = ScrollController();
    var quizName = quizEngine.quizName;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          quizName,
          style: AppTextStyles.headline5,
        ),
      ),
      body: Container(
        child: Center(
          child: QuizResultWidget(
            quizEngine: quizEngine,
          ),
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: BottomNavigationMenu(
        controller: controller,
        onSearchClick: () => {},
        searchCallback: (String filter) => {
          Provider.of<RideSafeProvider>(context, listen: false)
              .filterQuizes(filter)
        },
      ),
    );
  }
}

class QuizResultWidget extends StatefulWidget {
  final QuizEngine quizEngine;
  late final int score;

  QuizResultWidget({
    Key? key,
    required this.quizEngine,
  }) : super(key: key) {
    score =
        (quizEngine.correctAnswers / quizEngine.totalQuestions * 100).round();
  }

  @override
  State<QuizResultWidget> createState() => _QuizResultWidgetState();
}

class _QuizResultWidgetState extends State<QuizResultWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: Text(
            (widget.score > 80) ? 'Congrats!' : 'You can do better!',
            style: const TextStyle(
                fontSize: 48,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          'Your score is: ${widget.quizEngine.correctAnswers}/${widget.quizEngine.totalQuestions}'
              .toUpperCase(),
          style: const TextStyle(
              fontSize: 16, height: 1, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          '+${widget.quizEngine.correctAnswers} POINTS',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        OutlinedButton(
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(color: AppColors.primaryColor)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0)),
                textStyle: const MaterialStatePropertyAll(TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontWeight: FontWeight.bold)),
                backgroundColor: MaterialStatePropertyAll(
                    createMaterialColor(AppColors.primaryColor))),
            onPressed: () => Navigator.pushNamed(context, '/quizes'),
            child: const Text(
              'Play other quizzes',
              style: TextStyle(color: AppColors.secondaryTextColor),
            )),
        Image(
          image: widget.score > 80
              ? const AssetImage('assets/images/good_result.png')
              : const AssetImage('assets/images/bad_result.png'),
          width: MediaQuery.of(context).size.width * 0.7,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
