import 'package:flutter/material.dart';
import 'package:rescue_terminal/components/water_ripple.dart';
import 'dart:math';
import 'package:rescue_terminal/views/rescueScope/util.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:rescue_terminal/components/widget_default_btn.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';
import 'package:rescue_terminal/components/widget_empty.dart';

class RescueScope extends StatefulWidget {
  const RescueScope({super.key});

  @override
  State<RescueScope> createState() => _RescueScopeState();
}

class _RescueScopeState extends State<RescueScope>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final globalKey = GlobalKey<AnimatedListState>();
  final GlobalKey<WaterRippleState> rippleKey = GlobalKey<WaterRippleState>();

  // late AnimationController _controller;
  // late Animation<double> _scaleAnimation;
  // late Animation<double> _maskPainterAnimation;
  // bool _isAnimating = false;
  // double _currentAngle = 0.0;
  // double _targetAngle = 0.0;
  // dynamic _gyroscopeEvent;

  // 是否初始状态
  bool initStatus = true;

  // 搜索状态
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // );

    // _scaleAnimation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInOut,
    // );

    // _maskPainterAnimation =
    //     Tween<double>(begin: _currentAngle, end: _targetAngle).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    // );
    //
    // // Start the animation
    // _controller.forward();
    //
    // // 添加状态监听器
    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.forward ||
    //       status == AnimationStatus.reverse) {
    //     setState(() {
    //       _isAnimating = true;
    //     });
    //   } else if (status == AnimationStatus.completed ||
    //       status == AnimationStatus.dismissed) {
    //     setState(() {
    //       _isAnimating = false;
    //     });
    //   }
    // });
    //
    // // 陀螺仪
    // _gyroscopeEvent =
    //     gyroscopeEventStream(samplingPeriod: SensorInterval.normalInterval)
    //         .listen(
    //   (GyroscopeEvent event) {
    //     if (!_isAnimating) {
    //       var z = event.z;
    //       if (z > 0.1) {
    //         double randomNum = (Random().nextDouble() * 10).floor() / 10;
    //         _updateRotation(_targetAngle - randomNum);
    //         Future.delayed(const Duration(milliseconds: 1000), () {
    //           _updateRotation(_targetAngle + randomNum);
    //         });
    //       } else if (z < -0.1) {
    //         double randomNum = (Random().nextDouble() * 10).floor() / 10;
    //         _updateRotation(_targetAngle + randomNum);
    //         Future.delayed(const Duration(milliseconds: 1000), () {
    //           _updateRotation(_targetAngle - randomNum);
    //         });
    //       }
    //     }
    //   },
    //   onError: (e) {
    //     debugPrint('Sensor Not Found');
    //   },
    //   cancelOnError: true,
    // );
  }

  @override
  void dispose() {
    // _gyroscopeEvent.cancel();
    // _controller.dispose();
    super.dispose();
  }

  // void _updateRotation(double newAngle) {
  //   setState(() {
  //     _currentAngle = _targetAngle;
  //     _targetAngle = newAngle;
  //     _maskPainterAnimation =
  //         Tween<double>(begin: _currentAngle, end: _targetAngle).animate(
  //       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  //     );
  //     _controller.forward(from: 0.0); // 重新启动动画
  //   });
  // }

  // 进入搜救页面
  handleEnterRescue() {
    setState(() {
      initStatus = false;
      isSearching = true;
    });
  }

  // 开始搜救
  handleStartRescue() {
    setState(() {
      isSearching = true;
    });
    // 开始动画
    rippleKey.currentState?.startAnimation();
  }

  // 停止搜救
  handleStopRescue() {
    setState(() {
      isSearching = false;
    });
    // 停止动画
    rippleKey.currentState?.stopAnimation();
  }

  // 初始状态
  Widget widgetInitStatus() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/images/empty-light.png'),
            width: 269,
            height: 82,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: 24,
          ),
          WidgetDefaultBtn(
            name: '开始搜救',
            callback: handleEnterRescue,
            width: 110,
          ),
        ],
      ),
    );
  }

  // 已发现人员
  List<User> haveFoundPeopleRecord = [];

  // 扫描到的人员
  List<User> haveScanPeopleRecord = [];

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
            child: Text(
              isSearching ? '正在搜索附近人员...' : '已停止搜救',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 14,
              bottom: 14,
              left: 14,
            ),
            child: Row(
              children: [
                const Text(
                  '已发现',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '${haveFoundPeopleRecord.length}',
                    style: const TextStyle(
                      color: Color.fromRGBO(245, 97, 75, 1),
                    ),
                  ),
                ),
                const Text(
                  '人',
                ),
              ],
            ),
          ),
          haveFoundPeopleRecord.isEmpty
              ? const WidgetEmpty()
              : Expanded(
                  child: AnimatedList(
                    key: globalKey,
                    initialItemCount: haveFoundPeopleRecord.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                      Animation<double> animation,
                    ) {
                      //添加列表项时会执行渐显动画
                      final item = haveFoundPeopleRecord[index];
                      return _buildItem(item, animation);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  // 构建列表项
  Widget _buildItem(User item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 22),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(
              image: AssetImage(item.avatar),
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
                        item.name,
                        style: const TextStyle(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
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
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    '心率71，血压125/71，血氧98%',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    '体温36.5℃，IMEI: 653429838222',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/30 16:00
  * @description: 向雷达图添加扫描到的人员
  * @param
  * @return
  */
  handleAppendScanPeople() {
    final RenderBox renderBox =
        rippleKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = getRandomPositionInSector(size);
    final user = User(
      id: '#10002',
      name: '李逵',
      avatar: 'assets/images/construction-personnel.png',
      position: position,
    );
    setState(() {
      haveScanPeopleRecord.add(user);
      haveFoundPeopleRecord.insert(0, user);
    });
    if (globalKey.currentState != null) {
      globalKey.currentState!.insertItem(0);
    }
    // 设置一段时间后将新添加的标记置为 false，避免重复动画
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        haveScanPeopleRecord.last = User(
          id: haveScanPeopleRecord.last.id,
          name: haveScanPeopleRecord.last.name,
          avatar: haveScanPeopleRecord.last.avatar,
          position: haveScanPeopleRecord.last.position,
          isNew: false,
        );
      });
    });
  }

  Offset getRandomPositionInSector(Size size) {
    // 定义扇形中心为底部中心
    final center = Offset(size.width / 2, size.height - 100);
    // 计算扇形的半径，减去一定边距
    final radius = min(size.width, size.height) - 100;
    // 扇形的角度范围为60度到120度，以扇形底部中心为起点
    const angleOffset = 60;

    Offset newPosition = const Offset(0, 0);
    bool positionIsValid = false;
    // 避免一直找不到合适位置,所以如果随机5次，还没有合适位置，就算了
    int maxLoops = 40;
    int currLoop = 1;

    while (!positionIsValid) {
      final angle = angleOffset + Random().nextDouble() * 60; // 随机生成60度到120度的角度
      final angleInRadians = angle * pi / 180; // 将角度转换为弧度
      // 均匀生成随机半径
      final r = sqrt(Random().nextDouble()) * radius;
      // 通过极坐标计算出随机点的位置
      final x = center.dx + r * cos(angleInRadians);
      final y = center.dy + r * sin(-angleInRadians);
      newPosition = Offset(x, y);

      // 检查新位置是否与现有位置足够远
      positionIsValid = _isPositionValid(newPosition);
      currLoop += 1;
      if (currLoop > maxLoops) {
        positionIsValid = true;
      }
    }
    return newPosition;
  }

  bool _isPositionValid(Offset newPosition) {
    for (User item in haveScanPeopleRecord) {
      if ((item.position - newPosition).distance < 50) {
        return false; // 新位置与已生成的位置太近
      }
    }
    return true; // 新位置有效
  }

  // 扫描雷达
  Widget widgetScanningRadar() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      height: double.infinity,
                      child: WaterRipple(key: rippleKey),
                    ),
                    // AnimatedBuilder(
                    //   animation: _maskPainterAnimation,
                    //   builder: (context, child) {
                    //     return Transform.rotate(
                    //       // 旋转角度（弧度）
                    //       angle: _maskPainterAnimation.value,
                    //       child: CustomPaint(
                    //         // size: const Size(double.infinity, double.infinity),
                    //         size: Size(constraints.maxWidth, constraints.maxHeight),
                    //         painter: MaskPainter(
                    //           maskColor: const Color.fromRGBO(203, 215, 225, 1),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    ...haveScanPeopleRecord.map((user) {
                      return Positioned(
                        left: user.position.dx,
                        top: user.position.dy,
                        child: AnimatedOpacity(
                          opacity: user.isNew ? 0 : 1,
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              Text(user.id,
                                  style: const TextStyle(fontSize: 10)),
                              Text(user.name,
                                  style: const TextStyle(fontSize: 10)),
                              ClipOval(
                                child: Image(
                                  image: AssetImage(user.avatar),
                                  width: 33,
                                  height: 33,
                                  fit: BoxFit.cover, // 确保图片填充整个圆形
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: WidgetDefaultBtn(
                        name: '添加人员',
                        btnBgColor: const LinearGradient(
                          colors: [
                            Color.fromRGBO(101, 110, 126, 1),
                            Color.fromRGBO(101, 110, 126, 1)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        callback: handleAppendScanPeople,
                        width: 110,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: WidgetDefaultBtn(
              name: isSearching ? '停止搜救' : '开始搜救',
              btnBgColor: const LinearGradient(
                colors: [
                  Color.fromRGBO(255, 171, 119, 1),
                  Color.fromRGBO(244, 182, 134, 1),
                  Color.fromRGBO(245, 81, 64, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              callback: isSearching ? handleStopRescue : handleStartRescue,
              width: 110,
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
        widgetScanningRadar(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    MyColorScheme themeData = themeNotifier.themeData;
    return initStatus ? widgetInitStatus() : widgetRescueStatus(themeData);
  }

  @override
  bool get wantKeepAlive => true; // 控制是否保持页面状态
}
