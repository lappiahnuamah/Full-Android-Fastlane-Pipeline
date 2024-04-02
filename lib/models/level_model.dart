import 'package:flutter/material.dart';

class LevelModel {
  int id;
  String name;
  bool active;
  double progress;
  bool isLocked;
  Color color;

  LevelModel(
      {required this.id,
      required this.name,
      required this.active,
      required this.progress,
      required this.isLocked,
      required this.color});

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
        active: json['active'] ?? "",
        progress: json['progress'] ?? "",
        isLocked: json['is_locked'] ?? true,
        color: json['color']);
  }
}
