import 'package:flutter/material.dart';

import '../drawer/my_drawer.dart';

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Ride Safe'),
        ),
        body: Container(
          child: Center(
            child: Text('Quizz Page'),
          ),
        ),
        drawer: MyDrawer());
  }
}
