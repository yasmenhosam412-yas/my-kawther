import 'dart:math' as math;

import 'package:flutter/material.dart';

enum HealthServiceKind {
  ovulation,
  pregnancy,
  bloodPressure,
  bloodSugar,
  bodyWeight,
  vaccination,
  pharmacist,
  beauty,
}

class HealthCreativeIcon extends StatelessWidget {
  const HealthCreativeIcon({
    super.key,
    required this.kind,
    required this.color,
    this.size = 56,
  });

  final HealthServiceKind kind;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: size * 0.42,
              height: size * 0.42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 2,
            bottom: 2,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: color.withOpacity(0.16),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.18),
                  color.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: CustomPaint(
              painter: _ServiceIconPainter(kind: kind, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceIconPainter extends CustomPainter {
  _ServiceIconPainter({required this.kind, required this.color});

  final HealthServiceKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (kind) {
      case HealthServiceKind.ovulation:
        _paintOvulation(canvas, size, paint, fill);
      case HealthServiceKind.pregnancy:
        _paintPregnancy(canvas, size, paint, fill);
      case HealthServiceKind.bloodPressure:
        _paintPressure(canvas, size, paint, fill);
      case HealthServiceKind.bloodSugar:
        _paintSugar(canvas, size, paint, fill);
      case HealthServiceKind.bodyWeight:
        _paintWeight(canvas, size, paint, fill);
      case HealthServiceKind.vaccination:
        _paintVaccine(canvas, size, paint, fill);
      case HealthServiceKind.pharmacist:
        _paintPharmacist(canvas, size, paint, fill);
      case HealthServiceKind.beauty:
        _paintBeauty(canvas, size, paint, fill);
    }
  }

  void _paintOvulation(Canvas canvas, Size size, Paint paint, Paint fill) {
    final c = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(c, size.width * 0.28, paint);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: size.width * 0.28),
      -0.4,
      1.4,
      false,
      paint..strokeWidth = 4.4,
    );
    paint.strokeWidth = 2.2;
    canvas.drawCircle(
      Offset(c.dx + size.width * 0.18, c.dy - size.height * 0.16),
      3.6,
      fill,
    );
    canvas.drawCircle(c, 2.2, fill);
  }

  void _paintPregnancy(Canvas canvas, Size size, Paint paint, Paint fill) {
    final cx = size.width / 2;
    final head = Offset(cx, size.height * 0.30);
    canvas.drawCircle(head, size.width * 0.10, paint);
    final body = Path()
      ..moveTo(cx - 7, size.height * 0.42)
      ..quadraticBezierTo(
        cx - 16,
        size.height * 0.72,
        cx,
        size.height * 0.78,
      )
      ..quadraticBezierTo(
        cx + 18,
        size.height * 0.70,
        cx + 8,
        size.height * 0.42,
      );
    canvas.drawPath(body, paint);
    canvas.drawCircle(
      Offset(cx + 4, size.height * 0.62),
      3.2,
      fill,
    );
  }

  void _paintPressure(Canvas canvas, Size size, Paint paint, Paint fill) {
    final path = Path()
      ..moveTo(size.width * 0.50, size.height * 0.72)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.52,
        size.width * 0.16,
        size.height * 0.28,
        size.width * 0.36,
        size.height * 0.26,
      )
      ..cubicTo(
        size.width * 0.46,
        size.height * 0.24,
        size.width * 0.50,
        size.height * 0.34,
        size.width * 0.50,
        size.height * 0.38,
      )
      ..cubicTo(
        size.width * 0.50,
        size.height * 0.34,
        size.width * 0.54,
        size.height * 0.24,
        size.width * 0.64,
        size.height * 0.26,
      )
      ..cubicTo(
        size.width * 0.84,
        size.height * 0.28,
        size.width * 0.82,
        size.height * 0.52,
        size.width * 0.50,
        size.height * 0.72,
      );
    canvas.drawPath(path, paint);
    final line = Path()
      ..moveTo(size.width * 0.22, size.height * 0.50)
      ..lineTo(size.width * 0.34, size.height * 0.50)
      ..lineTo(size.width * 0.40, size.height * 0.38)
      ..lineTo(size.width * 0.50, size.height * 0.62)
      ..lineTo(size.width * 0.58, size.height * 0.44)
      ..lineTo(size.width * 0.66, size.height * 0.50)
      ..lineTo(size.width * 0.78, size.height * 0.50);
    canvas.drawPath(line, paint);
  }

  void _paintSugar(Canvas canvas, Size size, Paint paint, Paint fill) {
    final drop = Path()
      ..moveTo(size.width * 0.50, size.height * 0.20)
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.48,
        size.width * 0.50,
        size.height * 0.78,
      )
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.48,
        size.width * 0.50,
        size.height * 0.20,
      );
    canvas.drawPath(drop, paint);
    canvas.drawCircle(Offset(size.width * 0.50, size.height * 0.54), 4, fill);
    canvas.drawCircle(
      Offset(size.width * 0.42, size.height * 0.46),
      1.6,
      fill..color = color.withOpacity(0.55),
    );
    fill.color = color;
  }

  void _paintWeight(Canvas canvas, Size size, Paint paint, Paint fill) {
    final top = Offset(size.width * 0.50, size.height * 0.22);
    canvas.drawCircle(top, 3.2, fill);
    canvas.drawLine(top, Offset(size.width * 0.50, size.height * 0.78), paint);
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.36),
      Offset(size.width * 0.78, size.height * 0.36),
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.30, size.height * 0.50),
        width: 18,
        height: 16,
      ),
      0.15,
      math.pi - 0.3,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.70, size.height * 0.50),
        width: 18,
        height: 16,
      ),
      0.15,
      math.pi - 0.3,
      false,
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.38, size.height * 0.78),
      Offset(size.width * 0.62, size.height * 0.78),
      paint,
    );
  }

  void _paintVaccine(Canvas canvas, Size size, Paint paint, Paint fill) {
    canvas.save();
    canvas.translate(size.width * 0.50, size.height * 0.50);
    canvas.rotate(-0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-4, -16, 8, 22),
        const Radius.circular(3),
      ),
      paint,
    );
    canvas.drawRect(const Rect.fromLTWH(-7, -20, 14, 5), paint);
    canvas.drawLine(const Offset(0, 6), const Offset(0, 16), paint);
    canvas.drawCircle(const Offset(0, 18), 2.2, fill);
    canvas.restore();
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.70, size.height * 0.30),
        radius: 8,
      ),
      2.4,
      2.6,
      false,
      paint,
    );
  }

  void _paintPharmacist(Canvas canvas, Size size, Paint paint, Paint fill) {
    final bubble = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.22,
        size.height * 0.20,
        size.width * 0.56,
        size.height * 0.42,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(bubble, paint);
    final tail = Path()
      ..moveTo(size.width * 0.34, size.height * 0.60)
      ..lineTo(size.width * 0.28, size.height * 0.74)
      ..lineTo(size.width * 0.46, size.height * 0.60);
    canvas.drawPath(tail, paint);
    canvas.drawCircle(Offset(size.width * 0.38, size.height * 0.41), 2, fill);
    canvas.drawCircle(Offset(size.width * 0.50, size.height * 0.41), 2, fill);
    canvas.drawCircle(Offset(size.width * 0.62, size.height * 0.41), 2, fill);
  }

  void _paintBeauty(Canvas canvas, Size size, Paint paint, Paint fill) {
    final c = Offset(size.width / 2, size.height * 0.52);
    for (var i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * (2 * math.pi / 5);
      final p = Offset(
        c.dx + math.cos(angle) * 11,
        c.dy + math.sin(angle) * 11,
      );
      canvas.drawOval(
        Rect.fromCenter(center: p, width: 10, height: 16),
        paint,
      );
    }
    canvas.drawCircle(c, 4.2, fill);
    canvas.drawCircle(
      Offset(size.width * 0.74, size.height * 0.24),
      2.2,
      fill,
    );
    canvas.drawLine(
      Offset(size.width * 0.74, size.height * 0.16),
      Offset(size.width * 0.74, size.height * 0.32),
      paint..strokeWidth = 1.6,
    );
    canvas.drawLine(
      Offset(size.width * 0.66, size.height * 0.24),
      Offset(size.width * 0.82, size.height * 0.24),
      paint,
    );
    paint.strokeWidth = 2.2;
  }

  @override
  bool shouldRepaint(covariant _ServiceIconPainter oldDelegate) {
    return oldDelegate.kind != kind || oldDelegate.color != color;
  }
}
