import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String avatar;
  final Offset position;
  final bool isNew;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.position,
    this.isNew = true,
  });
}