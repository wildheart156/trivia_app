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
    final questions = await ApiService.fetchQuestions();

    setState(() {
      _questions = questions;
      _loading = false;
    });
  }
}