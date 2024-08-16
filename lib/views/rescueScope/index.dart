import 'package:flutter/material.dart';
import 'package:rescue_terminal/enums/theme.dart';
import 'package:rescue_terminal/components/common/WaterRipple.dart';

class RescueScope extends StatefulWidget {
  const RescueScope({super.key});

  @override
  State<RescueScope> createState() => _RescueScopeState();
}

class _RescueScopeState extends State<RescueScope> {
  final globalKey = GlobalKey<AnimatedListState>();
  var data = <String>['1', '2', '3', '4', '5', '6', '7', '8'];
  int counter = 2;

  // 搜救
  handleRescue() {}

  // 搜救按钮
  Widget widgetRescueBtn(String name, Gradient btnBgColor) {
    return Material(
      color: Colors.transparent, // 确保背景颜色是透明的，只显示渐变色
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: handleRescue,
        borderRadius: BorderRadius.circular(20), // 确保水波纹效果是圆角的
        child: Container(
          height: 40,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: btnBgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // 初始状态
  Widget widgetInitStatus(MyColorScheme themeData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
          image: AssetImage('assets/images/empty.png'),
          width: 269,
          height: 82,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 24,
        ),
        widgetRescueBtn('开始搜救', themeData.btnBgColor),
      ],
    );
  }

  // 已发现人员
  Widget widgetHaveFoundPeople(MyColorScheme themeData) {
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
            child: Text(
              '正在搜索附近人员...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeData.defaultTextColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 14,
              left: 14,
            ),
            child: Text(
              '已发现3人',
              style: TextStyle(
                color: themeData.defaultTextColor,
              ),
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: globalKey,
              initialItemCount: data.length,
              itemBuilder: (
                BuildContext context,
                int index,
                Animation<double> animation,
              ) {
                //添加列表项时会执行渐显动画
                return FadeTransition(
                  opacity: animation,
                  child: widgetPeopleRecord(themeData, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 人员列表
  Widget widgetPeopleRecord(MyColorScheme themeData, int index) {
    return Container(
      key: ValueKey(index),
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Image(
            image: AssetImage('assets/images/construction-personnel.png'),
            width: 44,
            height: 62,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8,
                    ),
                    child: Text(
                      '张云飞',
                      style: TextStyle(
                        color: themeData.defaultTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 5,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(124, 176, 80, 1),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: const Text(
                      '佩戴中',
                      style: TextStyle(
                        color: Color.fromRGBO(124, 176, 80, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  '心率71，血压125/71，血氧98%',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeData.defaultTextColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '体温36.5℃，IMEI: 653429838222',
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
    );
  }

  // 扫描雷达
  Widget widgetScanningRadar(MyColorScheme themeData) {
    return Expanded(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          child: const WaterRipple(),
        ),
        Positioned(
          bottom: 40,
          child: widgetRescueBtn(
            '停止搜救',
            const LinearGradient(
              colors: [
                Color.fromRGBO(255, 171, 119, 1),
                Color.fromRGBO(244, 182, 134, 1),
                Color.fromRGBO(245, 81, 64, 1)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    ));
  }

  // 搜索状态
  Widget widgetRescueStatus(MyColorScheme themeData) {
    return Row(
      children: [
        widgetHaveFoundPeople(themeData),
        widgetScanningRadar(themeData),
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
