import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';
import 'package:provider/provider.dart';

class DisplaySetting extends StatefulWidget {
  const DisplaySetting({super.key});

  @override
  State<DisplaySetting> createState() => _DisplaySettingState();
}

class _DisplaySettingState extends State<DisplaySetting> {
  final List<Map<String, dynamic>> themeOptions = [
    {'name': '普通模式', 'img': 'assets/images/light-theme.png', 'model': 'light'},
    {'name': '暗黑模式', 'img': 'assets/images/dark-theme.png', 'model': 'dark'},
  ];
  int themeIndexActive = 0;

  Widget widgetTheme() {
    List<Widget> themeAssemble = [];
    for (int i = 0; i < themeOptions.length; i++) {
      themeAssemble.add(
        Container(
          width: 240,
          margin: const EdgeInsets.only(left: 30),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  handleSelectTheme(i);
                },
                child: Image(
                  image: AssetImage(themeOptions[i]['img']),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      themeOptions[i]['name'],
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Visibility(
                      visible: themeIndexActive == i,
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      );
    }
    // return Expanded(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Padding(
    //         padding: EdgeInsets.only(top: 14, left: 30, bottom: 39),
    //         child: Text('显示设置'),
    //       ),
    //       SizedBox(
    //         width: 800,
    //         child: Wrap(
    //           runSpacing: 30, // 纵轴（垂直）方向间距
    //           children: [
    //             ...themeAssemble,
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 14, left: 30, bottom: 39),
          child: Text('显示设置'),
        ),
        SizedBox(
          width: 800,
          child: Wrap(
            runSpacing: 30, // 纵轴（垂直）方向间距
            children: [
              ...themeAssemble,
            ],
          ),
        )
      ],
    );
  }

  handleSelectTheme(int index) async {
    setState(() {
      themeIndexActive = index;
    });
    final String model = themeOptions[index]['model'];
    Provider.of<ThemeNotifier>(context, listen: false).updateThemeStatus(model);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeModel', model);
  }

  @override
  void initState() {
    super.initState();
    final String themeStatus = Provider.of<ThemeNotifier>(context, listen: false).themeStatus;
    final int findIndex = themeOptions.indexWhere((e) => e['model'] == themeStatus);
    setState(() {
      themeIndexActive = findIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widgetTheme();
  }
}
