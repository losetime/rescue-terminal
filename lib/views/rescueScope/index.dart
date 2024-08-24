import 'package:flutter/material.dart';
import 'package:rescue_terminal/components/common/WaterRipple.dart';
import 'dart:math';
import 'package:rescue_terminal/views/rescueScope/util.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:rescue_terminal/components/widget_default_btn.dart';

class RescueScope extends StatefulWidget {
  const RescueScope({super.key});

  @override
  State<RescueScope> createState() => _RescueScopeState();
}

class _RescueScopeState extends State<RescueScope>
    with SingleTickerProviderStateMixin {
  final globalKey = GlobalKey<AnimatedListState>();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _maskPainterAnimation;
  bool _isAnimating = false;
  double _currentAngle = 0.0;
  double _targetAngle = 0.0;
  dynamic _gyroscopeEvent;

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

  // 开始搜救
  handleStartRescue() {
    setState(() {
      isSearching = true;
    });
  }

  // 停止搜救
  handleStopRescue() {
    setState(() {
      isSearching = false;
    });
  }

  // 初始状态
  Widget widgetInitStatus() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
          callback: handleStartRescue,
          width: 110,
        ),
      ],
    );
  }

  // 已发现人员
  List<User> haveFoundPeopleRecord = [
    User(
        id: '#10001',
        name: '李云龙',
        avatar: 'assets/images/construction-personnel.png'),
    User(
        id: '#10001',
        name: '楚云飞',
        avatar: 'assets/images/construction-personnel.png'),
  ];

  Widget widgetHaveFoundPeopleRecord() {
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
            child: const Text(
              '正在搜索附近人员...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 14,
              left: 14,
            ),
            child: Text(
              '已发现3人',
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

  // 扫描雷达
  Widget widgetScanningRadar() {
    List<User> peopleRecord = [
      User(
          id: '#10001',
          name: '张雨廷',
          avatar: 'assets/images/construction-personnel.png'),
      User(
          id: '#10002',
          name: '李逵',
          avatar: 'assets/images/construction-personnel.png'),
      User(
          id: '#10003',
          name: '宋飞',
          avatar: 'assets/images/construction-personnel.png'),
    ];
    // 雷达扫描动态添加扫描人员
    List<Widget> scanningPeople = [];
    for (var i = 0; i < peopleRecord.length; i++) {
      double value = Random().nextDouble() * 100;
      // print(value);
      scanningPeople.add(Positioned(
        top: value,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: const Column(
            children: [
              Text('#123'),
              Text('张云飞'),
              Image(
                image: AssetImage('assets/images/construction-personnel.png'),
              ),
            ],
          ),
        ),
      ));
    }
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
          AnimatedBuilder(
            animation: _maskPainterAnimation,
            builder: (context, child) {
              return Transform.rotate(
                // angle: 0.5, // 旋转角度（弧度）
                angle: _maskPainterAnimation.value,
                child: CustomPaint(
                  size: const Size(double.infinity, double.infinity),
                  painter: MaskPainter(
                    maskColor: const Color.fromRGBO(203, 215, 225, 1),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 40,
            child: WidgetDefaultBtn(
              name: '停止搜救',
              btnBgColor: const LinearGradient(
                colors: [
                  Color.fromRGBO(255, 171, 119, 1),
                  Color.fromRGBO(244, 182, 134, 1),
                  Color.fromRGBO(245, 81, 64, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              callback: handleStopRescue,
              width: 110,
            ),
          ),
          // ...scanningPeople,
        ],
      ),
    );
  }

  // 搜索状态
  Widget widgetRescueStatus() {
    return Row(
      children: [
        widgetHaveFoundPeopleRecord(),
        widgetScanningRadar(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isSearching
          ? widgetRescueStatus()
          : widgetInitStatus(),
    );
  }
}
