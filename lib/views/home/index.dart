import 'package:flutter/material.dart';
import 'package:rescue_terminal/views/rescueScope/index.dart';
import 'package:rescue_terminal/views/whiteList/index.dart';
import 'package:rescue_terminal/views/setting/index.dart';
import 'package:rescue_terminal/views/whiteList/util.dart';
import 'package:rescue_terminal/store/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';

class Menu {
  final String name;
  final String img;
  final String activeImg;

  Menu({required this.name, required this.img, required this.activeImg});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _activeIndex = 0;
  final PageController _pageController = PageController();
  List<Menu> menuOptions = [
    Menu(
      name: '搜救范围',
      img: 'assets/images/rescue_scope.png',
      activeImg: 'assets/images/rescue_scope.png',
    ),
    Menu(
      name: '白名单',
      img: 'assets/images/white_list.png',
      activeImg: 'assets/images/white_list.png',
    ),
    Menu(
      name: '设置',
      img: 'assets/images/setting.png',
      activeImg: 'assets/images/setting.png',
    ),
    // Menu(
    //   name: '删除表',
    //   img: 'assets/images/setting.png',
    //   activeImg: 'assets/images/setting.png',
    // ),
    // Menu(
    //   name: '插入数据',
    //   img: 'assets/images/setting.png',
    //   activeImg: 'assets/images/setting.png',
    // ),
  ];

  // 选择菜单
  handleSelectMenu(int index) async {
    // if (index == 3) {
    //   final dbHelper = DatabaseHelper();
    //   // 删除表并重新创建
    //   await dbHelper.dropTable('white_list');
    // } else if (index == 4) {
    //   await WhiteListUtil().insertWhiteList();
    // } else {
    //   setState(() {
    //     _activeIndex = index;
    //   });
    // }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // 导航菜单
  Widget widgetMenu(MyColorScheme themeData) {
    List<Widget> getMenuWidget = [];
    for (int i = 0; i < menuOptions.length; i++) {
      getMenuWidget.add(
        InkWell(
          onTap: () {
            handleSelectMenu(i);
          },
          child: SizedBox(
            height: 120,
            child: Column(
              children: [
                Image(
                  image: AssetImage(menuOptions[i].img),
                  width: 44,
                  height: 44,
                  fit: BoxFit.fill,
                ),
                Text(menuOptions[i].name)
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      width: 120,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 0.5,
            color: themeData.borderColor,
          ),
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getMenuWidget,
          ),
        ),
      ),
    );
  }

  // 对应页面
  Widget widgetActivePage() {
    return PageView(
      controller: _pageController,
      // 禁用滑动切换
      physics: const NeverScrollableScrollPhysics(),
      // 改为上下滑动
      scrollDirection: Axis.vertical,
      children: const [
        RescueScope(), // 使用 AutomaticKeepAliveClientMixin
        WhiteList(),
        Setting(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    MyColorScheme themeData = themeNotifier.themeData;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child: const SafeArea(
          top: true,
          child: Offstage(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeData.appBgColor,
        ),
        child: Row(
          children: [
            widgetMenu(themeData),
            Expanded(
              child: widgetActivePage(),
            )
          ],
        ),
      ),
    );
  }
}
