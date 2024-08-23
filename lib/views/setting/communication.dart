import 'package:flutter/material.dart';
import 'package:rescue_terminal/components/input_widget.dart';
import 'package:rescue_terminal/enums/theme.dart';
import 'package:rescue_terminal/components/widget_default_btn.dart';

class CommunicationSetting extends StatefulWidget {
  const CommunicationSetting({super.key});

  @override
  State<CommunicationSetting> createState() => _CommunicationSettingState();
}

class _CommunicationSettingState extends State<CommunicationSetting> {
  // 正在配置
  bool configuring = false;
  bool isAdmin = false;

  /*
   * @desc 上一步
   */
  void handleLastStep() {
    setState(() {
      isAdmin = false;
    });
  }

  /*
   * @desc 下一步
   */
  void handleNextStep() {
    print(usernameController.text);
    print(passwordController.text);
    setState(() {
      isAdmin = true;
    });
  }

  /*
   * @desc 保存
   */
  void handleSave() {
    setState(() {
      configuring = false;
    });
  }

  /*
   * @desc 创建步骤
   */
  Widget createStepWidget(MyColorScheme themeData) {
    return Container(
      width: 650,
      height: 70,
      decoration: BoxDecoration(
          border: Border.all(
        color: themeData.defaultTextColor,
        width: 0.5,
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/is-admin-light.png'),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                '验证管理员身份',
                style: TextStyle(
                  color: themeData.defaultTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 150,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(isAdmin
                    ? 'assets/images/communication-light.png'
                    : 'assets/images/communication-light.png'),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                '设置通讯地址',
                style: TextStyle(
                  color: themeData.defaultTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*
   * @desc 验证管理员表单
   */
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _adminFormKey = GlobalKey<FormFieldState>();

  String? validatorUsername(v) {
    return v!.trim().isNotEmpty ? null : "用户名不能为空";
  }

  String? validatorPassword(v) {
    return v!.trim().isNotEmpty ? null : "密码不能为空";
  }

  Widget createVerifyAdminFormWidget(MyColorScheme themeData) {
    return Container(
      padding: const EdgeInsets.only(top: 60),
      width: 250,
      child: Form(
        key: _adminFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            createInputWidget(
                '管理员账号', usernameController, themeData, validatorUsername),
            const SizedBox(
              height: 15,
            ),
            createInputWidget(
                '管理员密码', passwordController, themeData, validatorPassword),
            const SizedBox(
              height: 30,
            ),
            WidgetDefaultBtn(
              name: '下一步',
              callback: handleNextStep,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  /*
   * @desc 通讯地址表单
   */
  final hostController = TextEditingController();
  final portController = TextEditingController();
  final keyController = TextEditingController();
  final _commumicationFormKey = GlobalKey<FormFieldState>();

  String? validatorHost(v) {
    return v!.trim().isNotEmpty ? null : "服务器地址不能为空";
  }

  String? validatorPort(v) {
    return v!.trim().isNotEmpty ? null : "端口不能为空";
  }

  String? validatorKey(v) {
    return v!.trim().isNotEmpty ? null : "key不能为空";
  }

  Widget createCommumicationFormWidget(MyColorScheme themeData) {
    return Container(
      padding: const EdgeInsets.only(top: 60),
      width: 250,
      child: Form(
        key: _commumicationFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            createInputWidget(
                '服务器地址', hostController, themeData, validatorHost),
            const SizedBox(
              height: 15,
            ),
            createInputWidget('端口', portController, themeData, validatorPort),
            const SizedBox(
              height: 15,
            ),
            createInputWidget('key', keyController, themeData, validatorKey),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: WidgetDefaultBtn(
                    name: '上一步',
                    btnBgColor: const LinearGradient(
                      colors: [
                        Color.fromRGBO(229, 234, 239, 1),
                        Color.fromRGBO(200, 213, 223, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    callback: handleLastStep,
                    width: double.infinity,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // 阴影颜色
                        spreadRadius: 0, // 阴影扩散范围
                        blurRadius: 4, // 模糊半径
                        offset: const Offset(1, 2), // 阴影偏移量 (x, y)
                      ),
                    ],
                    textColor: themeData.defaultTextColor,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: WidgetDefaultBtn(
                    name: '保存',
                    btnBgColor: themeData.btnBgColor,
                    callback: handleSave,
                    width: double.infinity,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 默认展示配置
  Widget widgetConfigurationDisplay() {
    return Expanded(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text('服务器地址：192.128.196.1.1'),
              ),
              Container(
                width: 200,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text('端口：2209'),
              ),
              Container(
                width: 200,
                padding: const EdgeInsets.only(bottom: 30),
                child: const Text('key：*************3243'),
              ),
              WidgetDefaultBtn(
                name: '去设置',
                callback: () {
                  setState(() {
                    configuring = true;
                  });
                },
              ),
            ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MyColorScheme themeData = GlobalThemData.themeData(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 14, left: 30, bottom: 30),
            child: Text('通讯配置'),
          ),
          configuring
              ? Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          createStepWidget(themeData),
                          isAdmin
                              ? createCommumicationFormWidget(themeData)
                              : createVerifyAdminFormWidget(themeData),
                        ],
                      ),
                    ),
                  ),
                )
              : widgetConfigurationDisplay()
        ],
      ),
    );
  }
}
