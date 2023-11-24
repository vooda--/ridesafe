import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/models/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final int index;
  final int totalQuestions;
  final Function(int) onAnswerSelected;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.index,
    required this.totalQuestions,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int _selectedAnswer = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Question ${widget.index + 1} of ${widget.totalQuestions}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.question.question,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        ...widget.question.answers.entries.map((e) {
          return RadioListTile(
            title: Text(e.value),
            value: widget.question.answers.keys.toList().indexOf(e.key),
            groupValue: _selectedAnswer,
            onChanged: (value) {
              setState(() {
                _selectedAnswer = value as int;
              });
              widget.onAnswerSelected(value!);
              _selectedAnswer = -1;
            },
          );
        }).toList(),
      ],
    );
  }
}