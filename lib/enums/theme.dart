import 'package:flutter/material.dart';

class MyColorScheme {
  // 字段
  final Color defaultTextColor;
  final dynamic btnBgColor;
  final Color btnTextColor;
  final dynamic appBgColor;
  final Color customColor1;

  // 构造函数
  MyColorScheme({
    required this.defaultTextColor,
    required this.btnBgColor,
    required this.btnTextColor,
    required this.appBgColor,
    this.customColor1 = Colors.redAccent,
  });
}

class GlobalThemData {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static MyColorScheme lightColorScheme = MyColorScheme(
    defaultTextColor: const Color.fromRGBO(101, 110, 126, 1),
    btnBgColor: const LinearGradient(
      colors: [
        Color.fromRGBO(101, 110, 126, 1),
        Color.fromRGBO(101, 110, 126, 1)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    btnTextColor: Colors.white,
    appBgColor: const LinearGradient(
      colors: [
        Color.fromRGBO(194, 207, 219, 1),
        Color.fromRGBO(231, 237, 243, 1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static MyColorScheme darkColorScheme = MyColorScheme(
    defaultTextColor: Colors.white,
    btnBgColor: const LinearGradient(
      colors: [
        Color.fromRGBO(229, 234, 239, 1),
        Color.fromRGBO(200, 213, 223, 1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    btnTextColor: const Color.fromRGBO(101, 110, 126, 1),
    appBgColor: const LinearGradient(
      colors: [
        Color.fromRGBO(28, 32, 37, 1),
        Color.fromRGBO(48, 53, 63, 1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static MyColorScheme themeData(BuildContext context) {
    bool isDark = isDarkMode(context);
    if (isDark) {
      return darkColorScheme;
    } else {
      return lightColorScheme;
    }
  }
}
