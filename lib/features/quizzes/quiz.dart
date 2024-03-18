import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/futureImage.dart';
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
          child: Center(
            child: SelectedQuiz(quiz),
          ),
        ),
        drawer: const MyDrawer());
  }
}

class SelectedQuiz extends StatefulWidget {
  final Quiz quiz;
  late final QuizEngine quizEngine;
  bool _isPreview = true;
  final bool _isFinished = false;

  SelectedQuiz(this.quiz, {Key? key}) : super(key: key) {
    quizEngine = QuizEngine(quiz.content!, quiz.title);
  }

  @override
  State<SelectedQuiz> createState() => _SelectedQuizState();
}

class _SelectedQuizState extends State<SelectedQuiz> {
  late Future<Uint8List> image;

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
    var provider = Provider.of<RideSafeProvider>(context, listen: false);

    setState(() {
      image = widget.quiz.image != null
          ? provider.getImage(context, widget.quiz.image!.id)
          : provider.loadImageAsUint8List('assets/images/default.jpeg');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget._isPreview
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget._isPreview = !widget._isPreview;
                          });
                        },
                        child: Text(
                          widget.quiz.description ?? 'Description',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureImage(image,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover)
                    ],
                  )
                : QuestionWidget(
                    question: widget.quizEngine.currentQuestion,
                    index: widget.quizEngine.questionNumber,
                    totalQuestions: widget.quizEngine.totalQuestions,
                    onContinue: onContinue,
                    onAnswerSelected: onAnswerSelected)),
      ],
    );
  }
}
