import 'package:flutter/material.dart';

class WidgetEmpty extends StatelessWidget {
  final double width;
  final double height;
  final String message;

  const WidgetEmpty(
      {super.key, this.width = 269, this.height = 82, this.message = '暂无内容'});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('assets/images/empty-light.png'),
              width: width,
              height: height,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
