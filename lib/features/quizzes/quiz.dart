import 'package:flutter/material.dart';

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
          title: const Text('Ride Safe'),
        ),
        body: Container(
          child: Center(
            child: Text(quiz?.title ?? 'Quiz empty'),
          ),
        ),
        drawer: const MyDrawer());
  }
}
