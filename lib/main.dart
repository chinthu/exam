import 'dart:math';

import 'package:flutter/material.dart';

import 'questions.dart';

void main() {
  runApp(const ScholarshipQuizApp());
}

class ScholarshipQuizApp extends StatelessWidget {
  const ScholarshipQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scholarship Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4BDB),
          primary: const Color(0xFF5B4BDB),
          secondary: const Color(0xFFFF8A3D),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizLength = categories.length * questionsPerCategory;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEEF0FF), Color(0xFFFFF4EA)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                children: [
                  const Text(
                    'Scholarship Quiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2C246B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$quizLength questions  ·  2 from every topic',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF5C567A)),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    key: const Key('attend-quiz'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8A3D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      final quiz = pickQuiz(questionBank, Random());
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => QuizScreen(questions: quiz)),
                      );
                    },
                    child: const Text('Attend Quiz'),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Topics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF2C246B)),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final category in categories)
                        Chip(
                          label: Text(category),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFD9D6F5)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.questions});

  final List<Question> questions;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int _score = 0;
  int? _selected;
  bool _locked = false;

  Question get _question => widget.questions[_index];

  void _choose(int optionIndex) {
    if (_locked) return;
    final isCorrect = optionIndex == _question.correctIndex;
    setState(() {
      _locked = true;
      _selected = optionIndex;
      if (isCorrect) _score += 1;
    });

    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted || !_locked) return;
        _goNext();
      });
      return;
    }

    final letter = String.fromCharCode(97 + _question.correctIndex);
    final answer = _question.correctAnswer;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Correct answer'),
          content: Text('The correct answer is: $letter) $answer'),
          actions: [
            FilledButton(
              key: const Key('wrong-answer-ok'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      if (mounted) _goNext();
    });
  }

  void _goNext() {
    if (_index + 1 >= widget.questions.length) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ScoreScreen(score: _score, total: widget.questions.length),
        ),
      );
      return;
    }
    setState(() {
      _index += 1;
      _selected = null;
      _locked = false;
    });
  }

  Color? _optionColor(int optionIndex) {
    if (_selected == null) return null;
    if (optionIndex == _question.correctIndex) return const Color(0xFF1B8A4A);
    if (optionIndex == _selected) return const Color(0xFFD64545);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final question = _question;
    final progress = (_index + 1) / widget.questions.length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_index + 1} of ${widget.questions.length}'),
        backgroundColor: const Color(0xFF5B4BDB),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F6FF), Color(0xFFFFF8F2)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE4E0F8),
                    color: const Color(0xFF5B4BDB),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Chip(
                    label: Text(question.category),
                    backgroundColor: const Color(0xFFEDE9FF),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  question.prompt,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.3),
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < question.options.length; i++) ...[
                  _OptionButton(
                    label: '${String.fromCharCode(97 + i)}) ${question.options[i]}',
                    color: _optionColor(i),
                    onPressed: _locked ? null : () => _choose(i),
                  ),
                  const SizedBox(height: 12),
                ],
                if (_selected != null && _selected == question.correctIndex)
                  const Text(
                    'Correct! Next question...',
                    style: TextStyle(color: Color(0xFF1B8A4A), fontWeight: FontWeight.w700),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final filled = color != null;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: filled ? color : Colors.white,
          foregroundColor: filled ? Colors.white : const Color(0xFF2C246B),
          disabledBackgroundColor: filled ? color : Colors.white,
          disabledForegroundColor: filled ? Colors.white : const Color(0xFF2C246B),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: filled ? color! : const Color(0xFFD9D6F5)),
          ),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key, required this.score, required this.total});

  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEEF0FF), Color(0xFFFFF4EA)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your score',
                    style: TextStyle(fontSize: 18, color: Color(0xFF5C567A)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$score / $total',
                    key: const Key('score-total'),
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2C246B),
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8A3D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                    ),
                    onPressed: () {
                      final quiz = pickQuiz(questionBank, Random());
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => QuizScreen(questions: quiz)),
                      );
                    },
                    child: const Text('Attend Quiz again'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (_) => false,
                      );
                    },
                    child: const Text('Back to home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
