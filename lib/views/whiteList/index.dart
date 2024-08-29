import 'package:flutter/material.dart';
import 'package:rescue_terminal/components/widget_default_btn.dart';
import 'package:rescue_terminal/views/whiteList/util.dart';
import 'package:rescue_terminal/components/widget_empty.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';

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
  List<Map<String, dynamic>> searchedWristbandRecord = [
    {
      'name': '李云龙',
      'imei': '123456789012398',
      'isOnline': 1, // SQLite 存储布尔值为 1 或 0
    },
    {
      'name': '楚云飞',
      'imei': '123456789012399',
      'isOnline': 1, // SQLite 存储布尔值为 1 或 0
    },
  ];

  bool isSearching = true;

  @override
  void initState() {
    super.initState();
    getWhiteList();
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '白名单',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
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

  // 获取白名单数据
  getWhiteList() async {
    var queryData = await WhiteListUtil().queryWhiteList();
    setState(() {
      whiteListRecord = List.from(queryData);
    });
  }

  // 删除白名单
  handleDeleteWhiteList(String imei) async {
    int findIndex =  whiteListRecord.indexWhere((e) => e['imei'] == imei);
    if (findIndex >= 0 && findIndex < whiteListRecord.length) {
      var removedItem = whiteListRecord[findIndex];
      // 在 AnimatedList 中移除元素
      whiteListGlobalKey.currentState!.removeItem(
        findIndex,
        (context, animation) => _buildItem(removedItem, animation, handleDeleteWhiteList, '1'),
      );
      // 从数据源中移除元素
      whiteListRecord.removeAt(findIndex);
    }
    // await WhiteListUtil().deleteWhiteList(id);
    // await getWhiteList();
  }

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
                const Text(
                  '白名单',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '白名单中的智能手环(佩戴人员)，不会出现在救援模式的搜索结果中。',
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
                      width: 110,
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

  // 构建列表项
  Widget _buildItem(Map<String, dynamic> item, Animation<double> animation, Function callback, String type) {
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: Container(
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
                      '佩戴人：${item['name']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'IMEI：${item['imei']}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            InkWell(
              onTap: () {
                callback(item['imei']);
              },
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
      ),
    );
  }

  Widget widgetHaveFoundPeopleRecord(MyColorScheme themeData) {
    return Container(
      width: 278,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 0.5,
            color: themeData.borderColor,
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
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(
                  width: 0.5,
                  color: themeData.borderColor,
                ),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  '白名单',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                      final item = whiteListRecord[index];
                      return _buildItem(item, animation, handleDeleteWhiteList, '1');
                    },
                  ),
                ),
        ],
      ),
    );
  }

  // 搜索手环，添加白名单
  Widget widgetSearchWristband() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(
              '添加白名单',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 30),
            child: Text(
              '正在搜索附近的智能手环...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          searchedWristbandRecord.isEmpty
              ? const WidgetEmpty()
              : Expanded(
                  child:Container(
                    width: 340,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedList(
                      key: wristbandGlobalKey,
                      initialItemCount: searchedWristbandRecord.length,
                      itemBuilder: (
                          BuildContext context,
                          int index,
                          Animation<double> animation,
                          ) {
                        //添加列表项时会执行渐显动画
                        final item = searchedWristbandRecord[index];
                        return _buildItem(item, animation, handleAddWristband, '2');
                      },
                    ),
                  ),
              ),
        ],
      ),
    );
  }

  handleAddWristband(String imei) {
    int findIndex =  searchedWristbandRecord.indexWhere((e) => e['imei'] == imei);
    if (findIndex >= 0 && findIndex < searchedWristbandRecord.length) {
      var removedItem = searchedWristbandRecord[findIndex];
      // 先触发搜索列表中的移除动画
      wristbandGlobalKey.currentState!.removeItem(
        findIndex,
            (context, animation) => _buildItem(removedItem, animation, handleAddWristband, '2'),
      );
      // 删除搜索列表中数据
      setState(() {
        searchedWristbandRecord.removeAt(findIndex);
      });
      // 将该数据添加到白名单
      setState(() {
        whiteListRecord.insert(0, removedItem);
      });
      // 执行列表过度动画
      whiteListGlobalKey.currentState!.insertItem(0);
    }
  }

  // 搜索状态
  Widget widgetRescueStatus(MyColorScheme themeData) {
    return Row(
      children: [
        widgetHaveFoundPeopleRecord(themeData),
        isSearching
            ? widgetSearchWristband()
            : widgetInitStatus(themeData),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    MyColorScheme themeData = themeNotifier.themeData;
    return Expanded(
      child: widgetRescueStatus(themeData),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
