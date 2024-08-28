import 'package:flutter/material.dart';

class DashedArrowPainter extends CustomPainter {
  final Color fillColor;
  DashedArrowPainter(this.fillColor);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint  = Paint()
      ..color = fillColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 创建虚线
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width - 10, size.height / 2); // Move to the arrow tip

    const dashWidth = 5;
    const dashSpace = 3;
    double distance = 0;

    while (distance < size.width - 10) {
      canvas.drawLine(Offset(distance, size.height / 2),
          Offset(distance + dashWidth, size.height / 2), linePaint);
      distance += dashWidth + dashSpace;
    }

    // Draw arrowhead
    final arrowHeadPaint  = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill; // Fill the arrowhead
    final arrowHeadPath = Path();
    arrowHeadPath.moveTo(size.width - 10, size.height / 2 - 5);
    arrowHeadPath.lineTo(size.width, size.height / 2);
    arrowHeadPath.lineTo(size.width - 10, size.height / 2 + 5);
    arrowHeadPath.close();

    canvas.drawPath(arrowHeadPath, arrowHeadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}