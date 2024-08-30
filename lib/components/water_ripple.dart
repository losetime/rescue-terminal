import 'dart:math';
import 'package:flutter/material.dart';
//
// class WaterRipple extends StatefulWidget {
//   final int count;
//   final Color color;
//
//   const WaterRipple({super.key, this.count = 3, this.color = const Color.fromRGBO(244, 139, 66, 1)});
//
//   @override
//   State<WaterRipple> createState() => WaterRippleState();
// }
//
// class WaterRippleState extends State<WaterRipple>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     _controller =
//     AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))
//       ..repeat();
//     super.initState();
//   }
//
//   void startAnimation() {
//     print('开始动画');
//     _controller.repeat();
//   }
//
//   void stopAnimation() {
//     print('停止动画');
//     _controller.stop();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return CustomPaint(
//           painter: WaterRipplePainter(_controller.value,count: widget.count,color: widget.color),
//         );
//       },
//     );
//   }
// }
//
// class WaterRipplePainter extends CustomPainter {
//   final double progress;
//   final int count;
//   final Color color;
//
//   final Paint _paint = Paint()..style = PaintingStyle.fill;
//
//   WaterRipplePainter(this.progress,
//       {this.count = 3, this.color = const Color.fromRGBO(244, 139, 66, 1)});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     double radius = min(size.width / 2, size.height / 2);
//
//     for (int i = count; i >= 0; i--) {
//       final double opacity = (1.0 - ((i + progress) / (count + 1)));
//       final Color opacityColor = color.withOpacity(opacity);
//       _paint.color = opacityColor;
//
//       double progressRadius = radius * ((i + progress) / (count + 1));
//
//       canvas.drawCircle(
//           Offset(size.width / 2, size.height / 2), progressRadius, _paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }


class WaterRipple extends StatefulWidget {
  final int count;
  final Color color;
  final double angle;

  const WaterRipple({
    Key? key,
    this.count = 4,
    this.color = const Color.fromRGBO(244, 139, 66, 1),
    this.angle = 60,
  }) : super(key: key);

  @override
  State<WaterRipple> createState() => WaterRippleState();
}

class WaterRippleState extends State<WaterRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 10000)
    )..repeat();
    super.initState();
  }

  void startAnimation() {
    print('开始动画');
    _controller.repeat();
  }

  void stopAnimation() {
    print('停止动画');
    _controller.stop();
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
        return CustomPaint(
          painter: WaterRipplePainter(
            _controller.value,
            count: widget.count,
            color: widget.color,
            angle: widget.angle,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class WaterRipplePainter extends CustomPainter {
  final double progress;
  final int count;
  final Color color;
  final double angle;

  WaterRipplePainter(
      this.progress, {
        this.count = 4,
        this.color = const Color.fromRGBO(244, 139, 66, 1),
        this.angle = 30,
      });

  @override
  void paint(Canvas canvas, Size size) {
    double maxRadius = size.height;
    Offset center = Offset(size.width / 2, size.height);

    for (int i = 0; i < count; i++) {
      // Calculate the adjusted progress for this ripple
      double rippleProgress = (progress + i / count) % 1.0;

      // Make the opacity fade out smoothly as the ripple reaches its maximum size
      final double opacity = (1.0 - rippleProgress).clamp(0.0, 1.0);

      Paint paint = Paint()
        ..style = PaintingStyle.fill
        ..color = color.withOpacity(opacity);

      // Adjust the radius based on the ripple progress
      double radius = maxRadius * rippleProgress;

      final startAngle = (270 - (angle / 2)) * pi / 180;
      final sweepAngle = angle * pi / 180;

      // Draw the wedge-like sector
      Path path = Path()
        ..moveTo(center.dx, center.dy)  // Move to the tip of the sector
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..lineTo(center.dx, center.dy)  // Close the sector path
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
