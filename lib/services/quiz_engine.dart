import 'package:ride_safe/services/models/question.dart';

class QuizEngine {
  int _currentQuestionNumber = 0;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  int _totalQuestions = 0;
  final List<Question> _questions;

  int get questionNumber => _currentQuestionNumber;
  int get correctAnswers => _correctAnswers;
  int get incorrectAnswers => _incorrectAnswers;
  int get totalQuestions => _totalQuestions;
  Question get currentQuestion => _questions[_currentQuestionNumber];
  bool get isFinished => _currentQuestionNumber >= _totalQuestions - 1;

  answerQuestion(int answer) {
    String key = currentQuestion.answers.keys.elementAt(answer);
    if (key == currentQuestion.correctAnswer) {
      _correctAnswers++;
      return true;
    } else {
      _incorrectAnswers++;
      return false;
    }
  }

  previousQuestion() {
    if (_currentQuestionNumber == 0) {
      return false;
    }
    _currentQuestionNumber--;
  }

  nextQuestion() {
    if (isFinished) {
      return false;
    }
    _currentQuestionNumber++;
  }

  QuizEngine(this._questions) {
    _totalQuestions = _questions.length;
    _currentQuestionNumber = 0;
    _correctAnswers = 0;
    _incorrectAnswers = 0;
  }
}
