import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Ride Safe quiz result'),
      ),
      body: Container(
        child: Center(
          child: QuizResultWidget(quizEngine: quizEngine,),
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: BottomNavigationMenu(controller: controller,
        onSearchClick: () => {

        },
        searchCallback: (String filter) => {
          Provider.of<RideSafeProvider>(context, listen: false).filterQuizes(filter)
        },),

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
    score = (quizEngine.correctAnswers / quizEngine.totalQuestions * 100).round();
  }

  @override
  State<QuizResultWidget> createState() => _QuizResultWidgetState();
}

class _QuizResultWidgetState extends State<QuizResultWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your score is ${widget.score}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'You answered ${widget.quizEngine.correctAnswers} questions correctly',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'You answered ${widget.quizEngine.incorrectAnswers} questions incorrectly',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        // Text(
        //   'You skipped ${widget.quizEngine.skippedQuestions} questions',
        //   style: const TextStyle(fontSize: 20),
        // ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'You answered ${widget.quizEngine.totalQuestions} questions in total',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'You answered ${widget.score}% of questions correctly',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'You took ${widget.quizEngine.timeSpent.inMinutes>0 ? widget.quizEngine.timeSpent.inMinutes : ''} ${(widget.quizEngine.timeSpent.inSeconds % 60).floor()}s to complete the quiz',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}