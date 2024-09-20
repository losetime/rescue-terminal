import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseHelper {
  final logger = Logger();

  // 私有静态实例，确保只有一个 DatabaseHelper 实例
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // 数据库实例
  static Database? _database;

  // 工厂构造函数，返回同一个实例
  factory DatabaseHelper() => _instance;

  // 私有命名构造函数，用于创建单例
  DatabaseHelper._internal();

  // 获取数据库实例，如果不存在则初始化
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 初始化数据库
  Future<Database> _initDatabase() async {
    // 获取数据库文件路径
    String path = join(await getDatabasesPath(), 'rescue_terminal_database.db');
    // 打开数据库，如果不存在则创建
    return await openDatabase(path, version: 1, onCreate: _onCreateTable);
  }

  // 创建数据库表
  // 在SQLite中，虽然你可以使用 BOOLEAN 类型定义字段，但实际上 SQLite 并没有原生的布尔类型。
  // SQLite 会将布尔值存储为 INTEGER，其中 0 表示 false，1 表示 true。
  Future<void> _onCreateTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imei TEXT,
        isOnline INTEGER,
        whiteList INTEGER
      )
    ''');
  }

  // 关闭数据库连接
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // 查询所有数据
  Future<List<Map<String, dynamic>>> queryAllData(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // 批量插入数据
  Future<void> insertTableData(String tableName, List data) async {
    final db = await database;
    try {
      // db.transaction((txn) 使用事务，出错自动回滚
      await db.transaction((txn) async {
        for (var user in data) {
          await txn.insert(tableName, user);
        }
      });
      Fluttertoast.showToast(msg: '数据写入成功');
    } catch(error) {
      Fluttertoast.showToast(msg: '数据写入失败');
    }
  }

  // 清空表方法
  Future<int> clearTable(String tableName) async {
    final db = await database;
    return await db.delete(tableName);
  }

  // 删除表方法
  Future<void> dropTable(String tableName) async {
    final db = await database;
    var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    if (tables.isNotEmpty) {
      await db.execute('DROP TABLE IF EXISTS $tableName');
      await _onCreateTable(db, 1);
    } else {
      logger.e('这个表不存在');
    }
  }
}