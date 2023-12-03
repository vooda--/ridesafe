import 'package:flutter/material.dart';
import 'package:ride_safe/features/quizzes/question.dart';
import 'package:ride_safe/services/quiz_engine.dart';

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
          backgroundColor: Colors.teal,
          title: Text(quiz.title ?? 'Quiz'),
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
    quizEngine = QuizEngine(quiz.content!);
  }

  @override
  State<SelectedQuiz> createState() => _SelectedQuizState();
}

class _SelectedQuizState extends State<SelectedQuiz> {

  void onContinue() {
    if (widget.quizEngine.isFinished) {
      Navigator.pushNamed(context, '/quizes/quiz/result', arguments: widget.quizEngine);
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget._isPreview ? Column(
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.network(
                widget.quiz.image?.pathToFile ??
                    'https://images.unsplash.com/photo-1593309404036-8e39088b6071?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1024&q=80',
                // Use the article's main image URL
                width: double.infinity, // Set the width as needed
                height: 300, // Set the height as needed
                fit: BoxFit.cover,
              ),
            ],
          ) : QuestionWidget(question: widget.quizEngine.currentQuestion,
              index: widget.quizEngine.questionNumber,
              totalQuestions: widget.quizEngine.totalQuestions,
              onContinue: onContinue,
              onAnswerSelected: onAnswerSelected)
        ),
      ],
    );
  }
}