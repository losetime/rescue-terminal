import 'package:flutter/material.dart';
import 'package:rescue_terminal/enums/theme.dart';
import 'package:rescue_terminal/components/WidgetDefaultBtn.dart';

class WhiteList extends StatefulWidget {
  const WhiteList({super.key});

  @override
  State<WhiteList> createState() => _WhiteListState();
}

class _WhiteListState extends State<WhiteList> {
  final whiteListGlobalKey = GlobalKey<AnimatedListState>();
  final wristbandGlobalKey = GlobalKey<AnimatedListState>();
  var data = <String>['1', '2', '3', '4', '5', '6', '7', '8'];

  // 白名单列表
  handleDeleteWhiteList() {}
  Widget widgetHaveFoundPeopleRecord(MyColorScheme themeData) {
    return Container(
      width: 278,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 0.5,
            color: Color.fromRGBO(177, 185, 209, 1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 61,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 14),
            decoration: const BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(
                  width: 0.5,
                  color: Color.fromRGBO(177, 185, 209, 1),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '白名单',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: themeData.defaultTextColor,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.help_outline,
                    size: 16,
                    color: Color.fromRGBO(153, 163, 174, 1),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: whiteListGlobalKey,
              initialItemCount: data.length,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              itemBuilder: (
                BuildContext context,
                int index,
                Animation<double> animation,
              ) {
                //添加列表项时会执行渐显动画
                return FadeTransition(
                  opacity: animation,
                  child: widgetPeopleRecord(themeData, index, '1', handleDeleteWhiteList),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 人员列表
  Widget widgetPeopleRecord(MyColorScheme themeData, int index, String type, GestureTapCallback callback) {
    return Container(
      key: ValueKey(index),
      margin: const EdgeInsets.only(bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Image(
                image: AssetImage('assets/images/wristband.png'),
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '佩戴人：张云飞',
                    style: TextStyle(
                      color: themeData.defaultTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'IMEI：653429838222',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeData.defaultTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: callback,
            child: Icon(
              type == '1' ? Icons.do_disturb_on_outlined : Icons.add_circle_outline,
              size: 20,
              color: const Color.fromRGBO(153, 163, 174, 1),
            ),
          ),
        ],
      ),
    );
  }

  // 初始状态
  handleSearch() {}
  Widget widgetInitStatus(MyColorScheme themeData) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '白名单',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: themeData.defaultTextColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.help_outline,
                  size: 16,
                  color: Color.fromRGBO(153, 163, 174, 1),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          WidgetDefaultBtn(
            name: '添加',
            btnBgColor: themeData.btnBgColor,
            callback: handleSearch,
          ),
        ],
      ),
    );
  }

  // 搜索手环，添加白名单
  handleAddWhiteList() {}
  Widget widgetSearchWristband(MyColorScheme themeData) {
    return Container(
      width: 340,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              '添加白名单',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeData.defaultTextColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              '正在搜索附近的智能手环...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeData.defaultTextColor,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: wristbandGlobalKey,
              initialItemCount: data.length,
              itemBuilder: (
                BuildContext context,
                int index,
                Animation<double> animation,
              ) {
                //添加列表项时会执行渐显动画
                return FadeTransition(
                  opacity: animation,
                  child: widgetPeopleRecord(themeData, index, '2', handleAddWhiteList),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 搜索状态
  Widget widgetRescueStatus(MyColorScheme themeData) {
    return Row(
      children: [
        widgetHaveFoundPeopleRecord(themeData),
        // widgetInitStatus(themeData),
        widgetSearchWristband(themeData),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MyColorScheme themeData = GlobalThemData.themeData(context);
    return Expanded(
      // child: widgetInitStatus(themeData),
      child: widgetRescueStatus(themeData),
    );
  }
}
