import 'package:flutter/material.dart';
import 'api_service.dart';
import 'question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  bool _loading = true;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    try {
      final questions = await ApiService.fetchQuestions();

      setState(() {
        _questions = questions;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print("Error loading questions: $e");
    }
  }

  void checkAnswer(String selected) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = selected;

      if (selected == _questions[_currentIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      _currentIndex++;
      _answered = false;
      _selectedAnswer = null;
    });
  }

  Color getButtonColor(String option) {
    if (!_answered) return Colors.blue;

    final correct = _questions[_currentIndex].correctAnswer;

    if (option == correct) {
      return Colors.green;
    } else if (option == _selectedAnswer) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔄 Loading screen
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 🏁 End of quiz
    if (_currentIndex >= _questions.length) {
      return Scaffold(
        body: Center(
          child: Text(
            "Final Score: $_score / ${_questions.length}",
            style: const TextStyle(fontSize: 24),
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Trivia Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Question text
            Text(question.question, style: const TextStyle(fontSize: 20)),

            const SizedBox(height: 20),

            // Answer buttons
            ...question.options.map((option) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getButtonColor(option),
                  ),
                  onPressed: _answered ? null : () => checkAnswer(option),
                  child: Text(option),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Next button
            ElevatedButton(
              onPressed: _answered ? nextQuestion : null,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
