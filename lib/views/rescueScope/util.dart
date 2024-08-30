import 'package:flutter/material.dart';
import 'dart:math';

class User {
  final String id;
  final String name;
  final String avatar;
  final Offset position;

  User({required this.id, required this.name, required this.avatar, required this.position});
}

class MaskPainter extends CustomPainter {
  final Color maskColor;
  final double cutoutAngle;

  MaskPainter({required this.maskColor, this.cutoutAngle = 30});

  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint()..color = maskColor;
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color.fromRGBO(207,217,227, 1), Color.fromRGBO(231, 237, 243, 1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final center = Offset(size.width / 2, size.height / 2);
    // final radius = sqrt((size.width) * (size.width) + (size.height) * (size.height)) / 2;
    final radius = sqrt((size.width - 200) * (size.width - 200) + (size.height - 200) * (size.height - 200)) / 2;
    // const startAngle = -pi / 2; // Start from the top
    const startAngle =  285 * pi / 180;
    final sweepAngle = 2 * pi - (cutoutAngle * pi / 180);
    final path = Path()
      ..moveTo(center.dx, center.dy)
    // ..lineTo(center.dx, 0)
      ..lineTo(
        center.dx + radius * cos(startAngle),
        center.dy + radius * sin(startAngle),
      )
      ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false
      )
      ..lineTo(center.dx, center.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}