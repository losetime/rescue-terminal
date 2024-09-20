import 'package:flutter/material.dart';
import 'package:rescue_terminal/store/database_helper.dart';

class User {
  final String id;
  final String imei;
  final String name;
  final String avatar;
  final Offset position;
  final bool isNew;
  bool isBeingRemoved;

  User({
    required this.id,
    required this.imei,
    required this.name,
    required this.avatar,
    required this.position,
    this.isNew = true,
    this.isBeingRemoved = false,
  });
}
class RescueScopeUtil {
  final dbHelper = DatabaseHelper();

  // 根据imei查询人员
  Future<List<Map<String, Object?>>> queryUserByImei(String imei) async {
    final db = await dbHelper.database;
    return await db.query('users', where: 'imei = ?', whereArgs: [imei]);
  }
}