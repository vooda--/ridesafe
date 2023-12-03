import 'package:flutter/material.dart';
import 'package:ride_safe/my_colors.dart';
import 'package:ride_safe/services/constants.dart';

import '../../services/helpers.dart';
import '../../services/models/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final int index;
  final int totalQuestions;
  final Function(String) onAnswerSelected;
  final Function() onContinue;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.index,
    required this.totalQuestions,
    required this.onAnswerSelected,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String _selectedAnswer = '';
  bool _isCorrect = false;

  // Color btnNextColor() {
  //   if (_selectedAnswer.isEmpty) {
  //     return createMaterialColor(AppColors.grayTextColor);
  //   } else if (_isCorrect) {
  //     return createMaterialColor(AppColors.successColor);
  //   } else {
  //     return createMaterialColor(Colors.red);
  //   }
  // }

  Color getColor(String answer) {
    if (_selectedAnswer.isEmpty) {
      return Colors.transparent;
    } else if (_isCorrect && _selectedAnswer == answer) {
      return createMaterialColor(AppColors.successColor);

      // return AppColors.successColor;
      //return Colors.green;
    } else if (!_isCorrect && _selectedAnswer == answer) {
      return createMaterialColor(AppColors.dangerColor);
      // return Colors.red;//AppColors.dangerColor;
    } else if (widget.question.correctAnswer == answer && _selectedAnswer.isNotEmpty) {
      return createMaterialColor(AppColors.successColor);
    }
      else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final MyColors myColors = Theme.of(context).extension<MyColors>()!;

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
                  // color: myColors.blackTextColor,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                // width: MediaQuery.of(context).size.width * 0.8,
                child: LinearProgressIndicator(
                  value: widget.index / widget.totalQuestions,
                  minHeight: 8,
                  backgroundColor: AppColors.whiteColor,
                  color: AppColors.primaryColor,
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
                  style: OutlinedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu',
                    ),
                    backgroundColor: MaterialStateColor.resolveWith((state)=>getColor(e.key)),
                    minimumSize:
                        Size(double.infinity, 48),
                    // Set minimum width to 100%
                    shape:
                      RoundedRectangleBorder(
                        side: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  onPressed: () {
                    print('PRessed!');
                    setState(() {
                      _selectedAnswer = e.key;
                      _isCorrect = widget.onAnswerSelected(e.key);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(e.value, maxLines: 3, overflow: TextOverflow.ellipsis), flex: 9,),
                      (e.key == widget.question.correctAnswer && _selectedAnswer.isNotEmpty) ?
                      Expanded(
                        flex: 1,
                        child: IconButton(icon: const Icon(Icons.info, color: Colors.white,), iconSize: 30, onPressed: () => {
                          print('Icon clicked')
                        }),
                      ) : SizedBox(height: 0, width: 0,)
                    ],
                  ),
                ),
          );
        }).toList(),
        Visibility(
          visible: _selectedAnswer.isNotEmpty,
          child: Container(
              margin: const EdgeInsets.only(top: 24),
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                  ),
                  backgroundColor: createMaterialColor(AppColors.primaryColor),//MaterialStateColor.resolveWith((state)=>getColor('A')),
                  minimumSize: const Size(150, 48),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  widget.onContinue();
                  _selectedAnswer = '';
                },
                child: const Text('Continue'),
              )),
        )
      ],
    );
  }
}
