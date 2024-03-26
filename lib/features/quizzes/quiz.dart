import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/quizzes/question.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';
import 'package:ride_safe/services/quiz_engine.dart';

import '../../services/constants.dart';
import '../../services/models/quiz.dart';
import '../drawer/my_drawer.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    final Quiz quiz = ModalRoute.of(context)!.settings.arguments as Quiz;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            quiz.title ?? 'Quiz',
            style: AppTextStyles.headline5,
          ),
        ),
        body: Container(
          child: SelectedQuiz(quiz),
        ),
        drawer: const SafeArea(child: MyDrawer()));
  }
}

class SelectedQuiz extends StatefulWidget {
  final Quiz quiz;
  late final QuizEngine quizEngine;
  // bool _isPreview = true;
  final bool _isFinished = false;

  SelectedQuiz(this.quiz, {Key? key}) : super(key: key) {
    quizEngine = QuizEngine(quiz.content!, quiz.title);
  }

  @override
  State<SelectedQuiz> createState() => _SelectedQuizState();
}

class _SelectedQuizState extends State<SelectedQuiz> {
  void onContinue() {
    if (widget.quizEngine.isFinished) {
      Navigator.pushNamed(context, '/quizes/quiz/result',
          arguments: widget.quizEngine);
    } else {
      setState(() {
        widget.quizEngine.nextQuestion();
      });
    }
  }

  bool onAnswerSelected(String answer) {
    return widget.quizEngine.answerQuestion(answer);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: QuestionWidget(
                  question: widget.quizEngine.currentQuestion,
                  index: widget.quizEngine.questionNumber,
                  totalQuestions: widget.quizEngine.totalQuestions,
                  onContinue: onContinue,
                  onAnswerSelected: onAnswerSelected)),
        ],
      ),
    );
  }
}
