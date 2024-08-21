import 'package:flutter/material.dart';
import 'package:rescue_terminal/views/rescueScope/index.dart';
import 'package:rescue_terminal/views/whiteList/index.dart';
import 'package:rescue_terminal/enums/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget menuWidget() {
    return Container(
      width: 120,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 0.5,
            color: Color.fromRGBO(177, 185, 209, 1),
          ),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/rescue_scope.png'),
                  width: 44,
                  height: 44,
                  fit: BoxFit.fill,
                ),
                Text('搜救范围')
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/white_list.png'),
                  width: 44,
                  height: 44,
                  fit: BoxFit.fill,
                ),
                Text('白名单')
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/setting.png'),
                  width: 44,
                  height: 44,
                  fit: BoxFit.fill,
                ),
                Text('设置')
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MyColorScheme themeData = GlobalThemData.themeData(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeData.appBgColor,
        ),
        child:Row(
          children: [
            menuWidget(),
            // const RescueScope(),
            const WhiteList(),
          ],
        ),
      ),

    );
  }
}
