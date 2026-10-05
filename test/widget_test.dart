import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scholarship_quiz/figures.dart';
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

  testWidgets('home screen starts a quiz', (WidgetTester tester) async {
    await tester.pumpWidget(const ScholarshipQuizApp());
    expect(find.text('Attend Quiz'), findsOneWidget);

    await tester.tap(find.byKey(const Key('attend-quiz')));
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of 15'), findsOneWidget);
  });
}
