import 'package:flutter/material.dart';
import 'package:rescue_terminal/views/home/index.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rescue_terminal/store/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:rescue_terminal/service/http/index.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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
    baseUrl: "http://192.168.35.50:3000",
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

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '搜救终端',
//       // theme: GlobalThemData.lightThemeData,
//       // darkTheme: GlobalThemData.darkThemeData,
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       // home: const MyHomePage(title: 'Flutter Demo Home Page'),
//       home: const Home(),
//     );
//   }
// }
