import 'dart:isolate';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rescue_terminal/components/widget_default_btn.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rescue_terminal/service/api/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
// import 'package:install_plugin/install_plugin.dart';

class UpdateSetting extends StatefulWidget {
  const UpdateSetting({super.key});

  @override
  State<UpdateSetting> createState() => _UpdateSettingState();
}

class _UpdateSettingState extends State<UpdateSetting> {
  final commonApi = CommonAPI();
  dynamic updateInfo = {};
  bool isNeedUpdate = false;
  bool startDownload = false;
  int downloadProgress = 0;
  String downloadTaskId = '';
  String filePath = '';

  dynamic dialogSetState;

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    handleInspectUpdate();
    createIsolateNameServer();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/28 17:55
  * @description: 使用 IsolateNameServer 实现隔离通信,进行后台下载
  * @param
  * @return
  */
  createIsolateNameServer() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      dialogSetState(() {
        downloadProgress = data[2];
      });
      if (data[2] == 100) {
        handleInstall();
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  // @pragma('vm:entry-point')的作用是在 AOT（Ahead-of-Time）编译过程中，告诉 Dart 虚拟机（VM）保留被标记的方法或函数，即使它没有被显式调用。
  // 这通常用于回调函数或其他以反射、插件、或者框架形式调用的方法，它们的调用可能不会被静态分析器发现。
  @pragma('vm:entry-point')
  static void downloadCallback(String id, status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/27 11:56
  * @description: 检查更新
  * @param
  * @return
  */
  handleInspectUpdate() async {
    // 获取本地版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String clientVersion = packageInfo.version;
    // 获取远程版本
    final response = await commonApi.apiGetAppPackageInfo();
    updateInfo = response;
    final String serviceVersion = response['version'];
    // 比较版本
    if (clientVersion != serviceVersion) {
      setState(() {
        isNeedUpdate = true;
      });
    }
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/28 17:34
  * @description: 确定更新
  * @param
  * @return
  */
  handleConfirmUpdate(setState) {
    dialogSetState = setState;
    dialogSetState(() {
      startDownload = true;
    });
    downloadFile();
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/28 15:57
  * @description: 获取公共存储路径
  * @param
  * @return
  */
  Future<String?> getDownloadDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      // 获取 Android 上公共下载文件夹
      directory = await getDownloadsDirectory();
      debugPrint('公共下载文件夹-- $directory');
    } else if (Platform.isIOS) {
      // iOS 的话获取应用沙盒目录
      directory = await getApplicationDocumentsDirectory();
    }

    return directory?.path;
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/27 17:05
  * @description: 下载文件
  * @param
  * @return
  */
  downloadFile() async {
    // 检查存储权限
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      final directoryPath = await getDownloadDirectory();
      if (directoryPath == null) return;
      String fileName = 'app-release.apk';
      filePath = '$directoryPath/$fileName';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      downloadTaskId = (await FlutterDownloader.enqueue(
        url: 'http://192.168.35.50:8080/app-release.apk',
        // 保存的目录路径，确保是公共存储路径
        savedDir: directoryPath,
        // 文件名
        fileName: fileName,
        // 是否显示通知
        showNotification: true,
        // 点击通知后是否打开文件
        openFileFromNotification: true,
        // 设置为 true，表示保存到公共存储
        saveInPublicStorage: true,
      ))!;
    } else {
      Fluttertoast.showToast(msg: '没有存储权限');
    }
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/28 19:25
  * @description: 安装应用
  * @param
  * @return
  */
  handleInstall() async {
    debugPrint('开始安装');
    FlutterDownloader.open(taskId: downloadTaskId);
    SystemNavigator.pop();
    // final res = await InstallPlugin.install(filePath);
    // if(res['isSuccess']) {
    //   Fluttertoast.showToast(msg: '安装成功');
    // } else {
    //   Fluttertoast.showToast(msg: '安装失败，请重试');
    // }
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/27 13:42
  * @description: 展示更新对话框
  * @param
  * @return
  */
  showUpdateModal(BuildContext context, themeData, themeStatus) {
    List<Widget> widgetVersion = [];
    final content = updateInfo['content'];
    for (int i = 0; i < content.length; i++) {
      widgetVersion.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            '${i + 1}. ${content[i]}',
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      );
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent, // 背景设置为透明
              content: Container(
                width: 450,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  gradient: themeData.appBgColor,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '更新',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '版本号： ${updateInfo['version']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        '更新内容：',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ...widgetVersion,
                    const SizedBox(height: 20),
                    startDownload
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 300,
                                height: 3,
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                  valueColor:
                                      const AlwaysStoppedAnimation(Colors.blue),
                                  value: downloadProgress / 100,
                                ),
                              ),
                              Text('$downloadProgress%'),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              WidgetDefaultBtn(
                                name: '取消',
                                btnBgColor: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(229, 234, 239, 1),
                                    Color.fromRGBO(200, 213, 223, 1),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                callback: () {
                                  Navigator.pop(context, "确定");
                                },
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withOpacity(0.2), // 阴影颜色
                                    spreadRadius: 1, // 阴影扩散范围
                                    blurRadius: 2, // 模糊半径
                                    offset: const Offset(1, 1), // 阴影偏移量 (x, y)
                                  ),
                                ],
                                textColor: themeData.defaultTextColor,
                                border: themeStatus == 'dark',
                                height: 30,
                                width: 80,
                                fontSize: 12,
                              ),
                              const SizedBox(width: 14),
                              WidgetDefaultBtn(
                                name: '更新',
                                btnBgColor: themeData.btnBgColor,
                                callback: () {
                                  handleConfirmUpdate(setState);
                                },
                                height: 30,
                                width: 80,
                                fontSize: 12,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 默认展示配置
  Widget widgetConfigurationDisplay(
      BuildContext context, themeData, themeStatus) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                isNeedUpdate ? '发现新版本' : '最新版本，无需更新',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: const Text(
                '当前版本：V1.0.0',
              ),
            ),
            Offstage(
              offstage: !isNeedUpdate,
              child: WidgetDefaultBtn(
                name: '立即更新',
                callback: () {
                  showUpdateModal(context, themeData, themeStatus);
                },
                width: 120,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    MyColorScheme themeData = themeNotifier.themeData;
    String themeStatus = themeNotifier.themeStatus;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 14, left: 30, bottom: 30),
            child: Text('版本更新'),
          ),
          widgetConfigurationDisplay(context, themeData, themeStatus),
        ],
      ),
    );
  }
}
