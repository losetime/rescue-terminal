import 'package:flutter/material.dart';
import 'package:rescue_terminal/enums/theme.dart';

class WidgetEmpty extends StatelessWidget {
  final double width;
  final double height;
  final String message;
  const WidgetEmpty({super.key, this.width = 269, this.height = 82, this.message = '暂无内容' });

  @override
  Widget build(BuildContext context) {
    MyColorScheme themeData = GlobalThemData.themeData(context);
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
            Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: themeData.defaultTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
