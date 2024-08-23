import 'package:flutter/material.dart';
import 'package:rescue_terminal/enums/theme.dart';
import 'package:rescue_terminal/components/widget_default_btn.dart';
import 'package:rescue_terminal/views/whiteList/util.dart';
import 'package:rescue_terminal/components/widget_empty.dart';

class WhiteList extends StatefulWidget {
  const WhiteList({super.key});

  @override
  State<WhiteList> createState() => _WhiteListState();
}

class _WhiteListState extends State<WhiteList> {
  final whiteListGlobalKey = GlobalKey<AnimatedListState>();
  final wristbandGlobalKey = GlobalKey<AnimatedListState>();

  // 已添加白名单
  List<Map<String, dynamic>> whiteListRecord = []; 

  // 搜索到的手环列表
  List<Map<String, dynamic>> searchedWristbandRecord = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    getWhiteList();
  }

  // 获取白名单数据
  getWhiteList() async {
    var queryData = await WhiteListUtil().queryWhiteList();
    setState(() {
      whiteListRecord = queryData;
    });
  }

  // 白名单列表
  handleDeleteWhiteList() {}

  handleWhiteListHelp(MyColorScheme themeData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // 背景设置为透明
          content: Container(
            width: 350,
            height: 168,
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              gradient: themeData.appBgColor,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '白名单',
                  style: TextStyle(
                    color: themeData.defaultTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '白名单中的智能手环(佩戴人员)，不会出现在救援模式的搜索结果中。',
                    style: TextStyle(
                      color: themeData.defaultTextColor,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WidgetDefaultBtn(
                      name: '我知道了',
                      btnBgColor: themeData.btnBgColor,
                      callback: () {
                        Navigator.pop(context, "确定");
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

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
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: InkWell(
                    onTap: () {
                      handleWhiteListHelp(themeData);
                    },
                    child: const Icon(
                      Icons.help_outline,
                      size: 16,
                      color: Color.fromRGBO(153, 163, 174, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          whiteListRecord.isEmpty
              ? const WidgetEmpty(
                  width: 200,
                  height: 69,
                )
              : Expanded(
                  child: AnimatedList(
                    key: whiteListGlobalKey,
                    initialItemCount: whiteListRecord.length,
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                    itemBuilder: (
                      BuildContext context,
                      int index,
                      Animation<double> animation,
                    ) {
                      //添加列表项时会执行渐显动画
                      return FadeTransition(
                        opacity: animation,
                        child: widgetPeopleRecord(
                            themeData, index, '1', handleDeleteWhiteList),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  // 人员列表
  Widget widgetPeopleRecord(MyColorScheme themeData, int index, String type,
      GestureTapCallback callback) {
    return Container(
      key: ValueKey(index),
      margin: const EdgeInsets.only(bottom: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(
                image: type == '1'
                    ? const AssetImage('assets/images/wristband.png')
                    : const AssetImage('assets/images/wristband-online.png'),
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
                    '佩戴人：${whiteListRecord[index]['name']}',
                    style: TextStyle(
                      color: themeData.defaultTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'IMEI：${whiteListRecord[index]['imei']}',
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
              type == '1'
                  ? Icons.do_disturb_on_outlined
                  : Icons.add_circle_outline,
              size: 20,
              color: const Color.fromRGBO(153, 163, 174, 1),
            ),
          ),
        ],
      ),
    );
  }

  // 初始状态
  handleSearch() {
    setState(() {
      isSearching = true;
    });
  }

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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Text(
              '添加白名单',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeData.defaultTextColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Text(
              '正在搜索附近的智能手环...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeData.defaultTextColor,
                fontSize: 16,
              ),
            ),
          ),
          searchedWristbandRecord.isEmpty
              ? const WidgetEmpty()
              : Container(
            width: 340,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Expanded(
              child: AnimatedList(
                key: wristbandGlobalKey,
                initialItemCount: searchedWristbandRecord.length,
                itemBuilder: (
                    BuildContext context,
                    int index,
                    Animation<double> animation,
                    ) {
                  //添加列表项时会执行渐显动画
                  return FadeTransition(
                    opacity: animation,
                    child: widgetPeopleRecord(
                        themeData, index, '2', handleAddWhiteList),
                  );
                },
              ),
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
        isSearching
            ? widgetSearchWristband(themeData)
            : widgetInitStatus(themeData),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MyColorScheme themeData = GlobalThemData.themeData(context);
    return Expanded(
      child: widgetRescueStatus(themeData),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
