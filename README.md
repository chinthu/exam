# Scholarship Quiz

A Flutter web quiz taken from the scholarship syllabus. Each attempt loads **26 multiple-choice questions**: two shuffled questions from each of the 13 topics.

There are 13 topics, so two from every topic is 26 questions. That is the smallest set that still includes at least two questions from each topic.

A correct answer turns green and moves on. A wrong answer turns red, shows the correct answer in green, and waits for OK before the next question. The score is shown after the last question.

## Run locally

```bash
flutter pub get
flutter run -d chrome
```

## GitHub Pages

The site is published from the `gh-pages` branch:

https://chinthu.github.io/exam/

To rebuild it:

```bash
flutter build web --release --base-href "/exam/"
```
