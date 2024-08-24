import 'package:flutter/material.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';

/*
   * @desc 表单组件
   */
Widget createInputWidget(hintText, controller, MyColorScheme themeData,
    [String? Function(String?)? validator]) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: themeData.defaultTextColor,
        fontSize: 12,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
            color: themeData.defaultTextColor,
            width: 1,
        ),
      ),
      // 去掉padding
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(42, 176, 255, 1),
        ),
      ),
    ),
    // 校验用户名
    validator: validator,
    style: TextStyle(
      color: themeData.defaultTextColor,
      fontSize: 12,
    ),
    cursorColor: const Color.fromRGBO(42, 176, 255, 1),
  );
}
