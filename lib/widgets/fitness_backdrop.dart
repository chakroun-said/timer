import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Ambient fitness backdrop drawn behind the whole app: a soft brand gradient
/// with interval dials, motion streaks and a pulse trace.
///
/// It is painted rather than shipped as a bitmap, so it stays sharp at any
/// window size, adds no download weight and keeps working offline. Everything
/// is deliberately low-contrast so content and the large countdown stay the
/// loudest thing on screen.
class FitnessBackdrop extends StatelessWidget {
  const FitnessBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return RepaintBoundary(
      child: CustomPaint(
        painter: _FitnessBackdropPainter(
          surface: colors.surface,
          primary: colors.primary,
          accent: const Color(0xFFF08A5D),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _FitnessBackdropPainter extends CustomPainter {
  _FitnessBackdropPainter({
    required this.surface,
    required this.primary,
    required this.accent,
  });

  final Color surface;
  final Color primary;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final w = size.width;
    final h = size.height;
    final bounds = Offset.zero & size;

    final top = Color.alphaBlend(primary.withAlpha(6), surface);
    final mid = Color.alphaBlend(primary.withAlpha(22), surface);
    final bottom = Color.alphaBlend(primary.withAlpha(38), surface);

    canvas.drawRect(
      bounds,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, mid, bottom],
          stops: const [0, 0.55, 1],
        ).createShader(bounds),
    );

    _paintGlow(
      canvas,
      Offset(w * 0.88, -h * 0.04),
      w * 0.8,
      primary.withAlpha(30),
    );
    _paintGlow(canvas, Offset(w * 0.02, h * 1.04), w * 0.65, accent.withAlpha(24));

    // On a wide screen the dial anchors the right edge; on a phone that spot is
    // covered by the list and app bar, so it drops into the empty lower half.
    final narrow = w < 700;
    _paintDials(
      canvas,
      narrow ? Offset(w * 1.0, h * 0.68) : Offset(w * 1.04, h * 0.16),
      narrow ? math.min(w, h) * 0.38 : w * 0.34,
    );
    _paintStreaks(canvas, size);
    _paintPulse(canvas, size);
  }

  void _paintGlow(Canvas canvas, Offset center, double radius, Color color) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = RadialGradient(colors: [color, color.withAlpha(0)]).createShader(rect),
    );
  }

  /// Three concentric dials with tick marks, echoing the app's set/rest rounds.
  void _paintDials(Canvas canvas, Offset center, double baseRadius) {
    const start = -2.42;
    const sweep = 2.3;
    final radii = [baseRadius, baseRadius * 1.32, baseRadius * 1.64];
    final alphas = [26, 42, 20];

    for (var i = 0; i < radii.length; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radii[i]),
        start,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = i == 1 ? 2 : 1.2
          ..strokeCap = StrokeCap.round
          ..color = primary.withAlpha(alphas[i]),
      );
    }

    final tickPaint = Paint()
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..color = primary.withAlpha(30);
    const ticks = 24;
    for (var i = 0; i <= ticks; i++) {
      final angle = start + sweep * i / ticks;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * (radii[1] - 7),
        center + direction * (radii[1] + 5),
        tickPaint,
      );
    }
  }

  /// Faint diagonal lines that read as speed rather than decoration.
  void _paintStreaks(Canvas canvas, Size size) {
    const angle = -0.28;
    final direction = Offset(math.cos(angle), math.sin(angle));
    final normal = Offset(-direction.dy, direction.dx);
    final reach = math.sqrt(size.width * size.width + size.height * size.height);
    final origin = Offset(size.width * 0.5, size.height * 0.55);

    for (var i = 0; i < 7; i++) {
      final center = origin + normal * ((i - 3) * size.height * 0.11);
      final even = i.isEven;
      canvas.drawLine(
        center - direction * reach * 0.5,
        center + direction * reach * 0.5,
        Paint()
          ..strokeWidth = even ? 1.0 : 2.2
          ..strokeCap = StrokeCap.round
          ..color = primary.withAlpha(even ? 7 : 10),
      );
    }
  }

  /// A heartbeat trace along the lower edge: the app's rhythm, hinted at.
  void _paintPulse(Canvas canvas, Size size) {
    final y = size.height * 0.9;
    final amplitude = size.height * 0.03;
    final beat = size.width * 0.24;
    final path = Path()..moveTo(0, y);

    var x = 0.0;
    while (x < size.width) {
      path
        ..lineTo(x + beat * 0.30, y)
        ..lineTo(x + beat * 0.42, y - amplitude)
        ..lineTo(x + beat * 0.54, y + amplitude * 0.55)
        ..lineTo(x + beat * 0.70, y)
        ..lineTo(x + beat, y);
      x += beat;
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = accent.withAlpha(24),
    );
  }

  @override
  bool shouldRepaint(_FitnessBackdropPainter oldDelegate) =>
      oldDelegate.surface != surface ||
      oldDelegate.primary != primary ||
      oldDelegate.accent != accent;
}
