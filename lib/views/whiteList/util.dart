import 'package:rescue_terminal/store/database_helper.dart';
import 'package:logger/logger.dart';
//
// class WhiteListScheme {
//   // 字段
//   final int id;
//   final String name;
//   final String imei;
//   final int isOnline;
//
//   // 构造函数
//   WhiteListScheme({
//     required this.id,
//     required this.name,
//     required this.imei,
//     required this.isOnline,
//   });
// }

class WhiteListUtil {
  final dbHelper = DatabaseHelper();
  final logger = Logger();

  // 批量插入白名单数据
  Future<void> insertWhiteList() async {
    List data = [
      {
        'name': '张三',
        'imei': '123456789012345',
        'isOnline': 1, // SQLite 存储布尔值为 1 或 0
      },
      {
        'name': '李四',
        'imei': '987654321098765',
        'isOnline': 0,
      },
    ];
    final db = await dbHelper.database;
    for(int i = 0; i < data.length; i++) {
      await db.insert('white_list', data[i]);
    }
  }

  // 删除白名单
  Future<void> deleteWhiteList(int id) async {
    final db = await dbHelper.database;
    try{
      await db.delete(
        'white_list', // 表名
        where: 'id = ?', // 删除条件
        whereArgs: [id], // 条件值
      );
    }catch(e){
      logger.e('删除白名单失败');
    }
  }

  // 获取白名单数据
  Future<List<Map<String, dynamic>>> queryWhiteList() async {
    final result = await dbHelper.queryAllData('white_list');
    logger.d('查询白名单--, $result');
    return result;
  }
}
