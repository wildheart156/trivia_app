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

      if (selected == _questions[_currentIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      _currentIndex++;
      _answered = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentIndex >= _questions.length) {
      return Scaffold(
        body: Center(
          child: Text("Final Score: $_score"),
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
            Text(question.question),
            const SizedBox(height: 20),

            ...question.options.map((option) {
              return ElevatedButton(
                onPressed: _answered ? null : () => checkAnswer(option),
                child: Text(option),
              );
            }),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _answered ? nextQuestion : null,
              child: const Text("Next"),
            )
          ],
        ),
      ),
    );
  }
}