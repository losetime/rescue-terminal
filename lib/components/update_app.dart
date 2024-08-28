import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rescue_terminal/service/api/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rescue_terminal/components/widget_default_btn.dart';


// class UpdateApp2 {
//   final commonApi = CommonAPI();
//   dynamic updateInfo = {};
//   bool startDownload = false;
//
//   /*
//   * @author: wwp
//   * @createTime: 2024/8/27 11:56
//   * @description: 检查更新
//   * @param
//   * @return
//   */
//   Future<bool> handleInspectUpdate() async {
//     // 获取本地版本
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     final String clientVersion = packageInfo.version;
//     // 获取远程版本
//     final response = await commonApi.apiGetAppPackageInfo();
//     updateInfo = response;
//     final String serviceVersion = response['version'];
//     Fluttertoast.showToast(msg: serviceVersion);
//     // 比较版本
//     if(clientVersion != serviceVersion) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   /*
//   * @author: wwp
//   * @createTime: 2024/8/27 13:42
//   * @description: 展示更新对话框
//   * @param
//   * @return
//   */
//   showUpdateModal(BuildContext context, themeData) {
//     List<Widget> widgetVersion = [];
//     final content = updateInfo['content'];
//     for(int i = 0; i < content.length; i++) {
//       widgetVersion.add(
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5),
//           child: Text(
//             '${i + 1}. ${content[i]}',
//             style: const TextStyle(
//               fontSize: 12,
//             ),
//           ),
//         ),
//       );
//     }
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.transparent, // 背景设置为透明
//           content: Container(
//             width: 450,
//             padding: const EdgeInsets.symmetric(
//               vertical: 20,
//               horizontal: 16,
//             ),
//             decoration: BoxDecoration(
//               gradient: themeData.appBgColor,
//               borderRadius: const BorderRadius.all(Radius.circular(4)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   '更新',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: Text(
//                     '版本号： ${updateInfo['version']}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 6),
//                   child: Text(
//                     '更新内容：',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//                 ...widgetVersion,
//                 const SizedBox(height: 20),
//                 startDownload ?
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(
//                       height: 3,
//                       child: LinearProgressIndicator(
//                         backgroundColor: Colors.grey[200],
//                         valueColor: const AlwaysStoppedAnimation(Colors.blue),
//                         value: .5,
//                       ),
//                     ),
//                     WidgetDefaultBtn(
//                       name: '取消',
//                       btnBgColor: themeData.btnBgColor,
//                       callback: () {
//                         Navigator.pop(context, "确定");
//                       },
//                       width: 110,
//                     )
//                   ],
//                 ) :
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     WidgetDefaultBtn(
//                       name: '更新',
//                       btnBgColor: themeData.btnBgColor,
//                       callback: () {
//                         startDownload = true;
//                         // Navigator.pop(context, "确定");
//                       },
//                       width: 110,
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   /*
//   * @author: wwp
//   * @createTime: 2024/8/27 17:05
//   * @description: 下载文件
//   * @param
//   * @return
//   */
//   downloadFile() {}
// }

class UpdateApp extends StatefulWidget {
  const UpdateApp({Key? key}) : super(key: key);

  @override
  State<UpdateApp> createState() => UpdateAppState();
}

class UpdateAppState extends State<UpdateApp> {

  final commonApi = CommonAPI();
  dynamic updateInfo = {};
  bool isNeedUpdate = false;
  bool startDownload = false;

  @override
  void initState() {
    super.initState();
    handleInspectUpdate();
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/27 11:56
  * @description: 检查更新
  * @param
  * @return
  */
  Future<bool> handleInspectUpdate() async {
    // 获取本地版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String clientVersion = packageInfo.version;
    // 获取远程版本
    final response = await commonApi.apiGetAppPackageInfo();
    updateInfo = response;
    final String serviceVersion = response['version'];
    Fluttertoast.showToast(msg: serviceVersion);
    // 比较版本
    if(clientVersion != serviceVersion) {
      return true;
    } else {
      return false;
    }
  }

  /*
  * @author: wwp
  * @createTime: 2024/8/27 13:42
  * @description: 展示更新对话框
  * @param
  * @return
  */
  showUpdateModal(BuildContext context, themeData) {
    List<Widget> widgetVersion = [];
    final content = updateInfo['content'];
    for(int i = 0; i < content.length; i++) {
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
                startDownload ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 3,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation(Colors.blue),
                        value: .5,
                      ),
                    ),
                    WidgetDefaultBtn(
                      name: '取消',
                      btnBgColor: themeData.btnBgColor,
                      callback: () {
                        Navigator.pop(context, "确定");
                      },
                      width: 110,
                    )
                  ],
                ) :
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WidgetDefaultBtn(
                      name: '更新',
                      btnBgColor: themeData.btnBgColor,
                      callback: () {
                        startDownload = true;
                        // Navigator.pop(context, "确定");
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

  /*
  * @author: wwp
  * @createTime: 2024/8/27 17:05
  * @description: 下载文件
  * @param
  * @return
  */
  downloadFile() {}

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
