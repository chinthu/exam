import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scholarship_quiz/main.dart';
import 'package:scholarship_quiz/questions.dart';

void main() {
  test('quiz takes two questions from every category', () {
    final quiz = pickQuiz(questionBank, Random(1));
    expect(quiz.length, categories.length * questionsPerCategory);

    final counts = <String, int>{};
    for (final question in quiz) {
      counts[question.category] = (counts[question.category] ?? 0) + 1;
    }
    expect(counts.length, categories.length);
    for (final count in counts.values) {
      expect(count, greaterThanOrEqualTo(2));
    }
  });

  testWidgets('home screen starts a quiz', (WidgetTester tester) async {
    await tester.pumpWidget(const ScholarshipQuizApp());
    expect(find.text('Attend Quiz'), findsOneWidget);

    await tester.tap(find.byKey(const Key('attend-quiz')));
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of 26'), findsOneWidget);
  });
}
