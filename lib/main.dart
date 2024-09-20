import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rescue_terminal/views/home/index.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/service/http/index.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:rescue_terminal/store/database_helper.dart';
import 'package:rescue_terminal/service/api/common.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  );
  // 初始化dio插件
  DioClient().init(
    baseUrl: "http://192.168.35.50:4001",
    defaultHeaders: {
      'Authorization': 'Bearer your_token', // 可选
    },
  );
  // 初始化下载器
  await FlutterDownloader.initialize(
      debug: true, // optional: 设置为false以禁用将日志打印到控制台 (default: true)
      ignoreSsl: true // option: 设置为false表示禁用HTTP链接 (default: false)
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getThemeModel();
    handleUserAsync();
  }

  // 读取缓存
  getThemeModel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? themeModel = prefs.getString('themeModel');
    if (mounted && (themeModel != null)) {
      Provider.of<ThemeNotifier>(context, listen: false)
          .updateThemeStatus(themeModel);
    }
  }

  // 将后端数据写入SQLite数据库
  handleUserAsync() async {
    try{
      final res = await CommonAPI().apiGetUserList();
      if(res['code'] == 20000) {
        List data = res['data'].map((item) => ({ "id": item['id'], "name": item['username'], "imei": item['id'], "isOnline": 1, "whiteList": 1})).toList();
        final dbHelper = DatabaseHelper();
        await dbHelper.clearTable('users');
        await dbHelper.insertTableData('users', data);
        // final userData = await dbHelper.queryAllData('users');
        // print('userData-- $userData');
        Fluttertoast.showToast(msg: '数据同步成功');
      } else {
        Fluttertoast.showToast(msg: '数据同步失败');
      }
    }catch(error){
      Fluttertoast.showToast(msg: '数据同步异常');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        MyColorScheme themeData = themeNotifier.themeData;
        return MaterialApp(
          title: '搜救终端',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: themeData.defaultTextColor),
            ),
            iconTheme: IconThemeData(
              color: themeData.defaultTextColor,
            ),
            hintColor: Colors.red,
            highlightColor: Colors.red,
            useMaterial3: true,
          ),
          home: const Home(),
        );
      },
    );
  }
}