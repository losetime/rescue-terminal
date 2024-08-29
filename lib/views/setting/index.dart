import 'package:flutter/material.dart';
import 'package:rescue_terminal/views/setting/display.dart';
import 'package:rescue_terminal/views/setting/communication.dart';
import 'package:rescue_terminal/views/setting/update.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int _activeIndex = 0;

  // 菜单
  Widget widgetMenu(MyColorScheme themeData) {
    final List<Map<String, dynamic>> menuOptions = [
      {'name': '显示设置'},
      {'name': '通讯配置'},
      {'name': '版本更新'}
    ];
    List<Widget> menuAssemble = [];
    for (int i = 0; i < menuOptions.length; i++) {
      menuAssemble.add(
        InkWell(
          onTap: () {
            handleSelectMenu(i);
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(left: 14),
            padding: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: themeData.borderColor,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  menuOptions[i]['name'],
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      width: 278,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 0.5,
            color: themeData.borderColor,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 61,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                    width: 0.5,
                    color: themeData.borderColor,
                  ),
                ),
              ),
              child: const Text(
                '设置',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...menuAssemble,
          ],
        ),
      ),
    );
  }

  // 选择菜单
  handleSelectMenu(int index) async {
    setState(() {
      _activeIndex = index;
    });
  }

  // 对应页面
  Widget widgetActivePage() {
    switch (_activeIndex) {
      case 0:
        return const DisplaySetting();
      case 1:
        return const CommunicationSetting();
      case 2:
        return const UpdateSetting();
      default:
        return const DisplaySetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    MyColorScheme themeData = themeNotifier.themeData;
    return Expanded(
      child: Row(
        children: [
          widgetMenu(themeData),
          widgetActivePage(),
        ],
      ),
    );
  }
}
