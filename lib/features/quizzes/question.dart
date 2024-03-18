import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/services/constants.dart';
import 'package:ride_safe/services/providers/ride_safe_provider.dart';

import '../../services/helpers.dart';
import '../../services/models/question.dart';
import '../futureImage.dart';

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
  late Future<Uint8List> image;

  // Color btnNextColor() {
  //   if (_selectedAnswer.isEmpty) {
  //     return createMaterialColor(AppColors.grayTextColor);
  //   } else if (_isCorrect) {
  //     return createMaterialColor(AppColors.successColor);
  //   } else {
  //     return createMaterialColor(Colors.red);
  //   }
  // }

  Color getForegroundColor(String answer) {
    if (_selectedAnswer.isEmpty) {
      return createMaterialColor(AppColors.primaryTextColor);
    } else if (_isCorrect && _selectedAnswer == answer) {
      return createMaterialColor(AppColors.secondaryTextColor);
    } else if (!_isCorrect && _selectedAnswer == answer) {
      return createMaterialColor(AppColors.secondaryTextColor);
    } else if (widget.question.correctAnswer == answer &&
        _selectedAnswer.isNotEmpty) {
      return createMaterialColor(AppColors.secondaryTextColor);
    }
    return createMaterialColor(AppColors.primaryTextColor);
  }

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
    } else if (widget.question.correctAnswer == answer &&
        _selectedAnswer.isNotEmpty) {
      return createMaterialColor(AppColors.successColor);
    } else {
      return Colors.transparent;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var provider = Provider.of<RideSafeProvider>(context, listen: false);
    setState(() {
      image = widget.question.imageId.isNotEmpty
          ? provider.getImage(context, int.parse(widget.question.imageId))
          : provider.loadImageAsUint8List('assets/images/default.jpeg');
    });
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
        const SizedBox(
          height: 36.0,
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: FutureImage(image, width: double.infinity, fit: BoxFit.cover),
        ),
        Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
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
                backgroundColor:
                    MaterialStateColor.resolveWith((state) => getColor(e.key)),
                foregroundColor: MaterialStateColor.resolveWith(
                    (states) => getForegroundColor(e.key)),
                minimumSize: const Size(double.infinity, 48),
                // Set minimum width to 100%
                shape: RoundedRectangleBorder(
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
                  Expanded(
                    flex: 9,
                    child: Text(e.value,
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                  ),
                  (e.key == widget.question.correctAnswer &&
                          _selectedAnswer.isNotEmpty)
                      ? Expanded(
                          flex: 1,
                          child: IconButton(
                              icon: const Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              iconSize: 20,
                              onPressed: () => {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Explanation'),
                                            content: Text(widget
                                                    .question.explanation ??
                                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Close'))
                                            ],
                                          );
                                        }),
                                    print('Icon clicked')
                                  }),
                        )
                      : const SizedBox(
                          height: 0,
                          width: 0,
                        )
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
                  backgroundColor: createMaterialColor(AppColors.primaryColor),
                  foregroundColor:
                      createMaterialColor(AppColors.secondaryTextColor),
                  //MaterialStateColor.resolveWith((state)=>getColor('A')),
                  minimumSize: const Size(130, 45),
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
