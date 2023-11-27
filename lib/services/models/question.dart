import 'package:hive/hive.dart';

class Question {
  final String question;
  final Map<String, String> answers;
  final String correctAnswer;

  Question({
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // Parse the raw answers JSON into a Map<String, String>
    Map<String, dynamic> rawAnswers = json["answers"];
    Map<String, String> parsedAnswers = {};
    rawAnswers.forEach((key, value) {
      parsedAnswers[key] = value.toString();
    });

    return Question(
      question: json["question"],
      answers: parsedAnswers,
      correctAnswer: json["correctAnswer"],
    );
  }
}

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final typeId = 3;

  @override
  Question read(BinaryReader reader) {
    return Question(
      question: reader.read(),
      answers: reader.read(),
      correctAnswer: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer.write(obj.question);
    writer.write(obj.answers);
    writer.write(obj.correctAnswer);
  }
}