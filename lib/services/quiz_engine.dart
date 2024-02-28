import 'package:ride_safe/services/models/question.dart';

class QuizEngine {
  int _currentQuestionNumber = 0;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  int _totalQuestions = 0;
  int _timeStarted = 0;
  int _timeFinished = 0;
  final List<Question> _questions;
  final String _quizName;

  int get questionNumber => _currentQuestionNumber;
  int get correctAnswers => _correctAnswers;
  int get incorrectAnswers => _incorrectAnswers;
  int get totalQuestions => _totalQuestions;
  String get quizName => _quizName;
  Duration get timeSpent => Duration(milliseconds: _timeFinished - _timeStarted);
  Question get currentQuestion => _questions[_currentQuestionNumber];
  bool get isFinished => _currentQuestionNumber >= _totalQuestions - 1;

  answerQuestion(String answer) {
    if (answer == currentQuestion.correctAnswer) {
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
      _timeFinished = DateTime.now().millisecondsSinceEpoch;
      return false;
    }
    _currentQuestionNumber++;
  }

  QuizEngine(this._questions, this._quizName) {
    _totalQuestions = _questions.length;
    _currentQuestionNumber = 0;
    _correctAnswers = 0;
    _incorrectAnswers = 0;
    _timeStarted = DateTime.now().millisecondsSinceEpoch;
  }
}
