import 'package:hive/hive.dart';

class QuizProgress extends HiveObject {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final int quizId;

  @HiveField(2)
  final int progress;

  @HiveField(3)
  final int correctAnswers;

  @HiveField(4)
  final int wrongAnswers;

  @HiveField(5)
  final int lastAttempted;

  QuizProgress({
    required this.userId,
    required this.quizId,
    required this.progress,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.lastAttempted,
  });

  QuizProgress.zero({
    required this.quizId,
    this.progress = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.lastAttempted = 0,
    this.userId = 0,
  });


  factory QuizProgress.fromJson(Map<String, dynamic> json) => QuizProgress(
    userId: json["userId"],
    quizId: json["quizId"],
    progress: json["progress"],
    correctAnswers: json["correctAnswers"],
    wrongAnswers: json["wrongAnswers"],
    lastAttempted: json["lastAttempted"],
  );

  Object? toJson() {
    return {
      "userId": userId,
      "quizId": quizId,
      "progress": progress,
      "correctAnswers": correctAnswers,
      "wrongAnswers": wrongAnswers,
      "lastAttempted": lastAttempted,
    };
  }
}

class QuizProgressAdapter extends TypeAdapter<QuizProgress> {
  @override
  final typeId = 8;

  @override
  QuizProgress read(BinaryReader reader) {
    return QuizProgress(
      userId: reader.read(),
      quizId: reader.read(),
      progress: reader.read(),
      correctAnswers: reader.read(),
      wrongAnswers: reader.read(),
      lastAttempted: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizProgress obj) {
    writer.write(obj.userId);
    writer.write(obj.quizId);
    writer.write(obj.progress);
    writer.write(obj.correctAnswers);
    writer.write(obj.wrongAnswers);
    writer.write(obj.lastAttempted);
  }
}