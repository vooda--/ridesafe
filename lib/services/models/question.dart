import 'package:hive/hive.dart';

class Question {
  final String question;
  final Map<String, String> answers;
  final String correctAnswer;
  final String explanation;
  final String imageId;

  Question({
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.explanation,
    required this.imageId
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
      explanation: json["explanation"] ?? '',
      imageId: json["imageId"] ?? '',
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
      answers: Map<String, String>.from(reader.read()), // Specify the type
      correctAnswer: reader.read(),
      explanation: reader.read(),
      imageId: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer.write(obj.question);
    writer.write(obj.answers);
    writer.write(obj.correctAnswer);
    writer.write(obj.explanation);
    writer.write(obj.imageId);
  }
}