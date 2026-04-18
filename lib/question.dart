import 'package:html_unescape/html_unescape.dart';

final unescape = HtmlUnescape();

class Question {
  final String question;
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    List<String> allOptions = List<String>.from(
      json['incorrect_answers'],
    ).map((e) => unescape.convert(e)).toList();

    String correct = unescape.convert(json['correct_answer']);

    allOptions.add(correct);
    allOptions.shuffle();

    return Question(
      question: unescape.convert(json['question']),
      correctAnswer: correct,
      options: allOptions,
    );
  }
}
