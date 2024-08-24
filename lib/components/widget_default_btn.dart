import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';

class WidgetDefaultBtn extends StatelessWidget {
  final String name;
  final GestureTapCallback callback;
  final Gradient? btnBgColor;
  final double width;
  final Color? textColor;
  final List<BoxShadow>? boxShadow;
  final bool border;

  const WidgetDefaultBtn({
    super.key,
    this.name = '按钮',
    this.btnBgColor,
    required this.callback,
    this.width = 100,
    this.textColor,
    this.boxShadow,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    MyColorScheme themeData = themeNotifier.themeData;
    return Container(
      height: 40,
      width: width,
      decoration: border
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
              ))
          : BoxDecoration(
              gradient: btnBgColor ?? themeData.btnBgColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: boxShadow,
            ),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
        ),
        onPressed: callback,
        child: Text(
          name,
          style: TextStyle(
            color: textColor ?? themeData.btnTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
