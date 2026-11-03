import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scholarship_quiz/figures.dart';
import 'package:scholarship_quiz/kerala_questions.dart';
import 'package:scholarship_quiz/main.dart';
import 'package:scholarship_quiz/questions.dart';

void main() {
  test('quiz has 15 questions and at least one from every category', () {
    final quiz = pickQuiz(questionBank, Random(1));
    expect(quiz.length, quizSize);

    final counts = <String, int>{};
    for (final question in quiz) {
      counts[question.category] = (counts[question.category] ?? 0) + 1;
    }
    expect(counts.length, categories.length);
    for (final count in counts.values) {
      expect(count, greaterThanOrEqualTo(1));
    }
  });

  testWidgets('shape question shows a picture', (WidgetTester tester) async {
    final shape = questionBank.firstWhere((question) => question.figure == Art.squareGrid);
    await tester.pumpWidget(
      MaterialApp(home: QuizScreen(questions: [shape, shape])),
    );
    expect(find.byKey(const Key('quiz-figure')), findsOneWidget);
    expect(find.text('How many squares do you see in this picture?'), findsOneWidget);
  });

  test('kerala special has 91 questions and each quiz picks 15', () {
    expect(keralaQuestionBank, hasLength(91));
    final prompts = keralaQuestionBank.map((question) => question.prompt).toSet();
    expect(prompts, hasLength(91));

    for (final question in keralaQuestionBank) {
      expect(question.options, hasLength(4));
      expect(question.correctIndex, inInclusiveRange(0, 3));
    }

    final quiz = pickRandomQuiz(keralaQuestionBank, Random(2));
    expect(quiz, hasLength(quizSize));
    expect(quiz.toSet(), hasLength(quizSize));
    for (final question in quiz) {
      expect(keralaQuestionBank.contains(question), isTrue);
    }
  });

  testWidgets('home screen starts a quiz', (WidgetTester tester) async {
    await tester.pumpWidget(const ScholarshipQuizApp());
    expect(find.text('Attend Quiz'), findsOneWidget);

    await tester.tap(find.byKey(const Key('attend-quiz')));
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of 15'), findsOneWidget);
  });

  testWidgets('kerala special starts a 15 question quiz', (WidgetTester tester) async {
    await tester.pumpWidget(const ScholarshipQuizApp());
    expect(find.text('Kerala Special'), findsOneWidget);

    await tester.tap(find.byKey(const Key('kerala-special')));
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of 15'), findsOneWidget);
    final prompts = keralaQuestionBank.map((question) => question.prompt).toSet();
    expect(
      find.byWidgetPredicate((widget) => widget is Text && prompts.contains(widget.data)),
      findsOneWidget,
    );
  });
}
