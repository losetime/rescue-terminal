import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';
import 'package:flutter_compass/flutter_compass.dart';

class RotatingFanshaped extends StatefulWidget {
  const RotatingFanshaped({super.key});

  @override
  State<RotatingFanshaped> createState() => RotatingFanshapedState();
}

class RotatingFanshapedState extends State<RotatingFanshaped> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    MyColorScheme themeData = themeNotifier.themeData;
    return StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          // 获取罗盘方向，单位是度, 0到180度和0到-180度，所以转弧度的时候要*-1
          double direction = snapshot.data?.heading ?? 0;
          // 将方向从度数转换为弧度
          double angle = direction * (pi / 180) * -1;
          return Container(
            width: 120,
            height: 130,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  color: themeData.borderColor
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text('N'),
                ),
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/direction-bg.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Transform.rotate(
                    angle: angle, // 根据动画更新旋转角度
                    child: CustomPaint(
                      size: const Size(90, 90),
                      painter: FanShapePainter(),
                    ),
                  ),
                )
              ],
            ),
          );
        },
    );
  }
}

class FanShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromRGBO(243, 127, 66, 1)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 绘制30度扇形
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // 起始角度为顶部（-90度）
      0.5236, // 扇形角度，单位为弧度 (30 度)
      // 0.05, // 扇形角度，单位为弧度 (30 度)
      true, // 是否连接到中心
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}