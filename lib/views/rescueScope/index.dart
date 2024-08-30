import 'package:flutter/material.dart';
import 'package:rescue_terminal/components/water_ripple.dart';
import 'dart:math';
import 'package:rescue_terminal/views/rescueScope/util.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:rescue_terminal/components/widget_default_btn.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';

class RescueScope extends StatefulWidget {
  const RescueScope({super.key});

  @override
  State<RescueScope> createState() => _RescueScopeState();
}

class _RescueScopeState extends State<RescueScope>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final globalKey = GlobalKey<AnimatedListState>();
  final GlobalKey<WaterRippleState> rippleKey = GlobalKey<WaterRippleState>();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _maskPainterAnimation;
  bool _isAnimating = false;
  double _currentAngle = 0.0;
  double _targetAngle = 0.0;
  dynamic _gyroscopeEvent;

  // 是否初始状态
  bool initStatus = true;

  // 搜索状态
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _maskPainterAnimation =
        Tween<double>(begin: _currentAngle, end: _targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();

    // 添加状态监听器
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        setState(() {
          _isAnimating = true;
        });
      } else if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        setState(() {
          _isAnimating = false;
        });
      }
    });

    // 陀螺仪
    _gyroscopeEvent =
        gyroscopeEventStream(samplingPeriod: SensorInterval.normalInterval)
            .listen(
      (GyroscopeEvent event) {
        if (!_isAnimating) {
          var z = event.z;
          if (z > 0.1) {
            double randomNum = (Random().nextDouble() * 10).floor() / 10;
            _updateRotation(_targetAngle - randomNum);
            Future.delayed(const Duration(milliseconds: 1000), () {
              _updateRotation(_targetAngle + randomNum);
            });
          } else if (z < -0.1) {
            double randomNum = (Random().nextDouble() * 10).floor() / 10;
            _updateRotation(_targetAngle + randomNum);
            Future.delayed(const Duration(milliseconds: 1000), () {
              _updateRotation(_targetAngle - randomNum);
            });
          }
        }
      },
      onError: (e) {
        debugPrint('Sensor Not Found');
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _gyroscopeEvent.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _updateRotation(double newAngle) {
    setState(() {
      _currentAngle = _targetAngle;
      _targetAngle = newAngle;
      _maskPainterAnimation =
          Tween<double>(begin: _currentAngle, end: _targetAngle).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.forward(from: 0.0); // 重新启动动画
    });
  }

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
  List<User> haveFoundPeopleRecord = [
    User(
        id: '#10001',
        name: '李云龙',
        avatar: 'assets/images/construction-personnel.png',
        position: const Offset(0, 0)),
    User(
        id: '#10001',
        name: '楚云飞',
        avatar: 'assets/images/construction-personnel.png',
        position: const Offset(0, 0)),
  ];

  List<User> haveScanPeopleRecord = [
    // User(
    //   id: '#10001',
    //   name: '张雨廷',
    //   avatar: 'assets/images/construction-personnel.png',
    //   location: [0, 0],
    // ),
  ];

  // User(
  // id: '#10002',
  // name: '李逵',
  // avatar: 'assets/images/construction-personnel.png',
  // ),
  // User(
  // id: '#10003',
  // name: '宋飞',
  // avatar: 'assets/images/construction-personnel.png',
  // ),

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
          WidgetDefaultBtn(
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
          const Padding(
            padding: EdgeInsets.only(
              top: 14,
              bottom: 14,
              left: 14,
            ),
            child: Row(
              children: [
                Text(
                  '已发现',
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Color.fromRGBO(245, 97, 75, 1),
                    ),
                  ),
                ),
                Text(
                  '人',
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: globalKey,
              initialItemCount: haveFoundPeopleRecord.length,
              itemBuilder: (
                BuildContext context,
                int index,
                Animation<double> animation,
              ) {
                //添加列表项时会执行渐显动画
                return FadeTransition(
                  opacity: animation,
                  child: widgetPeopleRecord(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 人员列表
  Widget widgetPeopleRecord(int index) {
    return Container(
      key: ValueKey(index),
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Image(
            image: AssetImage(haveFoundPeopleRecord[index].avatar),
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
                      haveFoundPeopleRecord[index].name,
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
    // double top = Random().nextDouble() * 100;
    // double left = Random().nextDouble() * 100;
    final size = MediaQuery.of(context).size;
    final position = getRandomPositionInSector(size);
    setState(() {
      haveScanPeopleRecord.add(
        User(
          id: '#10002',
          name: '李逵',
          avatar: 'assets/images/construction-personnel.png',
          position: position,
        ),
      );
    });
  }

  Offset getRandomPositionInSector(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20; // 留些边距
    final angle = Random().nextDouble() * 285 * pi / 180; // 285度扇形
    final r = sqrt(Random().nextDouble()) * radius; // 使分布更均匀
    return center + Offset(r * cos(angle), r * sin(angle));
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
                    ...haveScanPeopleRecord.map(
                      (user) {
                        return Positioned(
                          left: user.position.dx,
                          top: user.position.dy,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Column(
                              children: [
                                Text(user.id,
                                    style: const TextStyle(fontSize: 10)),
                                Text(user.name,
                                    style: const TextStyle(fontSize: 10)),
                                Image(
                                  image: AssetImage(user.avatar),
                                  width: 33,
                                  height: 33,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
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
