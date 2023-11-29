import 'package:flutter/material.dart';
import 'package:ride_safe/services/constants.dart';

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
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${widget.index + 1} of ${widget.totalQuestions}',
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(AppColors.primaryTextColor),
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                // width: MediaQuery.of(context).size.width * 0.8,
                child: LinearProgressIndicator(
                  value: widget.index / widget.totalQuestions,
                  backgroundColor: const Color(AppColors.secondaryColor),
                  color: const Color(AppColors.primaryColor),
                )),
          ],
        ),
        Container(
            margin: const EdgeInsets.only(top: 96, bottom: 24),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Text(
              textAlign: TextAlign.center,
              widget.question.question,
              style: AppTextStyles.headline5,
            )),
        const SizedBox(
          height: 10,
        ),
        ...widget.question.answers.entries.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton(
              style: ButtonStyle(
                textStyle: MaterialStatePropertyAll(
                  const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                minimumSize: MaterialStateProperty.all(Size(double.infinity, 48)), // Set minimum width to 100%
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      color: _selectedAnswer == widget.question.answers.keys.toList().indexOf(e.key) ? const Color(AppColors.primaryColor) : const Color(AppColors.buttonBorderColor),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              onPressed: () {
                var value = widget.question.answers.keys.toList().indexOf(e.key);
                setState(() {
                  _selectedAnswer = value as int;
                });
                widget.onAnswerSelected(value);
                _selectedAnswer = -1;
              },
              child: Text(e.value),
            ),
          );
        }).toList(),
      ],
    );
  }
}
