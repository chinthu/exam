import 'dart:math';

import 'package:flutter/material.dart';

enum Art {
  squareGrid,
  flowers,
  circleCluster,
  sizedCircles,
  shapeSequence,
  square,
  triangle,
  circle,
  cylinder,
  rectangle,
  pentagon,
  dotsUnevenA,
  dotsEqual,
  dotsUnevenC,
  dotsUnevenD,
  pig,
  rat,
  mouse,
  car,
}

class FigureView extends StatelessWidget {
  const FigureView({
    super.key,
    required this.art,
    this.compact = false,
    this.onColor = false,
  });

  final Art art;
  final bool compact;
  final bool onColor;

  @override
  Widget build(BuildContext context) {
    final color = onColor ? Colors.white : const Color(0xFF171717);
    final height = compact ? 56.0 : 108.0;
    if (_emoji.containsKey(art)) {
      return Text(_emoji[art]!, style: TextStyle(fontSize: compact ? 28 : 36));
    }
    return SizedBox(
      key: compact ? null : const Key('quiz-figure'),
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ArtPainter(art, color),
      ),
    );
  }
}

const _emoji = {
  Art.pig: '🐷',
  Art.rat: '🐀',
  Art.mouse: '🐭',
  Art.car: '🚗',
};

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.art, this.color);

  final Art art;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (art) {
      case Art.squareGrid:
        _squareGrid(canvas, size, paint);
      case Art.flowers:
        _flowers(canvas, size, fill);
      case Art.circleCluster:
        _circleCluster(canvas, size, paint);
      case Art.sizedCircles:
        _sizedCircles(canvas, size, paint, fill);
      case Art.shapeSequence:
        _sequence(canvas, size, paint);
      case Art.square:
        _shape(canvas, size, paint, Art.square);
      case Art.triangle:
        _shape(canvas, size, paint, Art.triangle);
      case Art.circle:
        _shape(canvas, size, paint, Art.circle);
      case Art.cylinder:
        _shape(canvas, size, paint, Art.cylinder);
      case Art.rectangle:
        _shape(canvas, size, paint, Art.rectangle);
      case Art.pentagon:
        _shape(canvas, size, paint, Art.pentagon);
      case Art.dotsUnevenA:
        _dotPair(canvas, size, fill, 3, 4);
      case Art.dotsEqual:
        _dotPair(canvas, size, fill, 4, 4);
      case Art.dotsUnevenC:
        _dotPair(canvas, size, fill, 5, 6);
      case Art.dotsUnevenD:
        _dotPair(canvas, size, fill, 2, 3);
      case Art.pig:
      case Art.rat:
      case Art.mouse:
      case Art.car:
        break;
    }
  }

  void _squareGrid(Canvas canvas, Size size, Paint paint) {
    final side = min(size.width, size.height) * 0.72;
    final rect = Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: side, height: side);
    canvas.drawRect(rect, paint);
    canvas.drawLine(Offset(rect.left, rect.center.dy), Offset(rect.right, rect.center.dy), paint);
    canvas.drawLine(Offset(rect.center.dx, rect.top), Offset(rect.center.dx, rect.bottom), paint);
  }

  void _flowers(Canvas canvas, Size size, Paint fill) {
    const counts = [4, 6, 8];
    final slot = size.width / 3;
    for (var i = 0; i < counts.length; i++) {
      final origin = Offset(slot * i + slot / 2, size.height * 0.38);
      _flowerCluster(canvas, origin, counts[i], fill);
      _label(canvas, 'Pattern ${i + 1}', Offset(slot * i + slot / 2, size.height * 0.86), fill.color);
    }
  }

  void _flowerCluster(Canvas canvas, Offset center, int count, Paint fill) {
    final cols = count <= 4 ? 2 : count == 6 ? 3 : 4;
    final rows = (count / cols).ceil();
    const gap = 16.0;
    for (var n = 0; n < count; n++) {
      final col = n % cols;
      final row = n ~/ cols;
      final dx = (col - (cols - 1) / 2) * gap;
      final dy = (row - (rows - 1) / 2) * gap;
      final point = center.translate(dx, dy);
      canvas.drawCircle(point, 2.4, fill);
      canvas.drawCircle(point.translate(0, -4), 1.6, fill);
      canvas.drawCircle(point.translate(0, 4), 1.6, fill);
      canvas.drawCircle(point.translate(-4, 0), 1.6, fill);
      canvas.drawCircle(point.translate(4, 0), 1.6, fill);
    }
  }

  void _circleCluster(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 28, paint);
    for (var i = 0; i < 3; i++) {
      final angle = -pi / 2 + i * 2 * pi / 3;
      canvas.drawCircle(center + Offset(cos(angle), sin(angle)) * 12, 5, paint);
    }
    for (var i = 0; i < 5; i++) {
      final angle = -pi / 2 + i * 2 * pi / 5;
      canvas.drawCircle(center + Offset(cos(angle), sin(angle)) * 46, 6, paint);
    }
  }

  void _sizedCircles(Canvas canvas, Size size, Paint paint, Paint fill) {
    const radii = [16.0, 11.0, 7.0, 24.0];
    final gap = size.width / 4;
    for (var i = 0; i < radii.length; i++) {
      final center = Offset(gap * i + gap / 2, size.height * 0.4);
      canvas.drawCircle(center, radii[i], paint);
      _label(canvas, '${i + 1}', Offset(center.dx, size.height * 0.82), fill.color);
    }
  }

  void _sequence(Canvas canvas, Size size, Paint paint) {
    final kinds = [Art.triangle, Art.circle, Art.triangle, Art.circle];
    final slot = size.width / kinds.length;
    for (var i = 0; i < kinds.length; i++) {
      _shape(canvas, Size(slot, size.height), paint, kinds[i], dx: slot * i);
    }
  }

  void _shape(Canvas canvas, Size size, Paint paint, Art kind, {double dx = 0}) {
    final box = Rect.fromCenter(
      center: Offset(dx + size.width / 2, size.height / 2),
      width: min(44, size.width * 0.7),
      height: min(44, size.height * 0.7),
    );
    switch (kind) {
      case Art.square:
        canvas.drawRect(box, paint);
      case Art.rectangle:
        canvas.drawRect(box.deflate(0).shift(Offset.zero), paint);
        canvas.drawRect(
          Rect.fromCenter(center: box.center, width: box.width, height: box.height * 0.62),
          paint,
        );
      case Art.triangle:
        final path = Path()
          ..moveTo(box.center.dx, box.top)
          ..lineTo(box.right, box.bottom)
          ..lineTo(box.left, box.bottom)
          ..close();
        canvas.drawPath(path, paint);
      case Art.circle:
        canvas.drawCircle(box.center, box.shortestSide / 2, paint);
      case Art.pentagon:
        final path = Path();
        for (var i = 0; i < 5; i++) {
          final angle = -pi / 2 + i * 2 * pi / 5;
          final point = box.center + Offset(cos(angle), sin(angle)) * (box.shortestSide / 2);
          if (i == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      case Art.cylinder:
        final top = Rect.fromCenter(
          center: Offset(box.center.dx, box.top + 8),
          width: box.width,
          height: 12,
        );
        final body = RRect.fromRectAndRadius(
          Rect.fromLTRB(box.left, top.center.dy, box.right, box.bottom - 4),
          const Radius.circular(2),
        );
        canvas.drawRRect(body, paint);
        canvas.drawOval(top, paint);
      default:
        break;
    }
  }

  void _dotPair(Canvas canvas, Size size, Paint fill, int left, int right) {
    _dots(canvas, Offset(size.width * 0.28, size.height / 2), left, fill);
    _dots(canvas, Offset(size.width * 0.72, size.height / 2), right, fill);
  }

  void _dots(Canvas canvas, Offset center, int count, Paint fill) {
    const gap = 9.0;
    final cols = count <= 3 ? count : 3;
    for (var n = 0; n < count; n++) {
      final col = n % cols;
      final row = n ~/ cols;
      final rows = (count / cols).ceil();
      final dx = (col - (cols - 1) / 2) * gap;
      final dy = (row - (rows - 1) / 2) * gap;
      canvas.drawCircle(center.translate(dx, dy), 3, fill);
    }
  }

  void _label(Canvas canvas, String text, Offset center, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _ArtPainter oldDelegate) {
    return oldDelegate.art != art || oldDelegate.color != color;
  }
}
