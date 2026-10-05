import 'dart:math';

import 'package:flutter/material.dart';

import 'questions.dart';

const _ink = Color(0xFF171717);
const _muted = Color(0xFF8A8680);
const _paper = Color(0xFFFAFAF8);
const _line = Color(0xFFE6E4DF);
const _correct = Color(0xFF1F8A4C);
const _wrong = Color(0xFFD14343);

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
        useMaterial3: true,
        scaffoldBackgroundColor: _paper,
        colorScheme: ColorScheme.fromSeed(seedColor: _ink, brightness: Brightness.light),
        fontFamily: 'Segoe UI',
      ),
      home: const HomeScreen(),
    );
  }
}

class PhoneShell extends StatelessWidget {
  const PhoneShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE7E5E0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final framed = constraints.maxWidth > 520;
          final radius = framed ? 36.0 : 0.0;
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: framed ? 28 : 0, horizontal: framed ? 16 : 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400, maxHeight: framed ? 860 : double.infinity),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _paper,
                    borderRadius: BorderRadius.circular(radius),
                    boxShadow: framed
                        ? const [BoxShadow(color: Color(0x1A000000), blurRadius: 40, offset: Offset(0, 18))]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizLength = categories.length * questionsPerCategory;
    return PhoneShell(
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            children: [
              const Text(
                'QUIZ',
                style: TextStyle(letterSpacing: 3, fontSize: 12, fontWeight: FontWeight.w600, color: _muted),
              ),
              const SizedBox(height: 10),
              const Text(
                'Scholarship\nQuiz',
                style: TextStyle(fontSize: 40, height: 1.05, fontWeight: FontWeight.w700, color: _ink),
              ),
              const SizedBox(height: 12),
              Text(
                '$quizLength questions, two from every topic.',
                style: const TextStyle(fontSize: 16, height: 1.4, color: _muted),
              ),
              const SizedBox(height: 28),
              FilledButton(
                key: const Key('attend-quiz'),
                style: FilledButton.styleFrom(
                  backgroundColor: _ink,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  final quiz = pickQuiz(questionBank, Random());
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => QuizScreen(questions: quiz)),
                  );
                },
                child: const Text('Attend Quiz'),
              ),
              const SizedBox(height: 36),
              const Text(
                'Topics',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _muted),
              ),
              const SizedBox(height: 8),
              for (final category in categories)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: _line)),
                  ),
                  child: Text(category, style: const TextStyle(fontSize: 15, color: _ink)),
                ),
            ],
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
  bool _showTick = false;

  Question get _question => widget.questions[_index];

  void _choose(int optionIndex) {
    if (_locked) return;
    final isCorrect = optionIndex == _question.correctIndex;
    setState(() {
      _locked = true;
      _selected = optionIndex;
      if (isCorrect) {
        _score += 1;
        _showTick = true;
      }
    });

    if (isCorrect) return;

    final letter = String.fromCharCode(97 + _question.correctIndex);
    final answer = _question.correctAnswer;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: _paper,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Correct answer', style: TextStyle(fontWeight: FontWeight.w700)),
          content: Text('The correct answer is: $letter) $answer'),
          actions: [
            FilledButton(
              key: const Key('wrong-answer-ok'),
              style: FilledButton.styleFrom(backgroundColor: _ink, foregroundColor: Colors.white),
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
    if (!mounted) return;
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
      _showTick = false;
    });
  }

  Color? _optionColor(int optionIndex) {
    if (_selected == null) return null;
    if (optionIndex == _question.correctIndex) return _correct;
    if (optionIndex == _selected) return _wrong;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final question = _question;
    final progress = (_index + 1) / widget.questions.length;
    return PhoneShell(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _ink),
                      ),
                      const Spacer(),
                      Text(
                        'Question ${_index + 1} of ${widget.questions.length}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: _line,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    question.category,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _muted),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question.prompt,
                    style: const TextStyle(fontSize: 26, height: 1.25, fontWeight: FontWeight.w700, color: _ink),
                  ),
                  const SizedBox(height: 28),
                  for (var i = 0; i < question.options.length; i++) ...[
                    _OptionButton(
                      label: '${String.fromCharCode(97 + i)}) ${question.options[i]}',
                      color: _optionColor(i),
                      onPressed: _locked ? null : () => _choose(i),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
              if (_showTick)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: _TickMark(onFinished: _goNext),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TickMark extends StatefulWidget {
  const _TickMark({required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<_TickMark> createState() => _TickMarkState();
}

class _TickMarkState extends State<_TickMark> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
      ..forward().whenComplete(() {
        if (mounted) widget.onFinished();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final appear = Curves.easeOutBack.transform((t / 0.35).clamp(0.0, 1.0));
        final fade = t < 0.62 ? 1.0 : (1 - ((t - 0.62) / 0.38)).clamp(0.0, 1.0);
        return Opacity(
          opacity: fade,
          child: Transform.scale(scale: 0.55 + (0.45 * appear), child: child),
        );
      },
      child: Container(
        width: 92,
        height: 92,
        decoration: const BoxDecoration(color: _correct, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 56),
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
          foregroundColor: filled ? Colors.white : _ink,
          disabledBackgroundColor: filled ? color : Colors.white,
          disabledForegroundColor: filled ? Colors.white : _ink,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: filled ? color! : _line),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
    return PhoneShell(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  'SCORE',
                  style: TextStyle(letterSpacing: 3, fontSize: 12, fontWeight: FontWeight.w600, color: _muted),
                ),
                const SizedBox(height: 12),
                Text(
                  '$score / $total',
                  key: const Key('score-total'),
                  style: const TextStyle(fontSize: 64, height: 1, fontWeight: FontWeight.w700, color: _ink),
                ),
                const SizedBox(height: 12),
                const Text(
                  'That is the end of this quiz.',
                  style: TextStyle(fontSize: 16, color: _muted),
                ),
                const Spacer(),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _ink,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    final quiz = pickQuiz(questionBank, Random());
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => QuizScreen(questions: quiz)),
                    );
                  },
                  child: const Text('Attend Quiz again'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _ink,
                    minimumSize: const Size.fromHeight(54),
                    side: const BorderSide(color: _line),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
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
    );
  }
}
