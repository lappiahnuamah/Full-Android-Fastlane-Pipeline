import 'package:flutter/material.dart';

class LevelModel {
  bool isLocked;
  Color color;
  String name;
  bool isCurrentLevel;

  LevelModel({
    required this.isCurrentLevel,
    required this.isLocked,
    required this.color,
    required this.name,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      isLocked: json['is_locked'] ?? true,
      color: getColorFromString(json['color'] ?? ''),
      name: json['name'] ?? '',
      isCurrentLevel: json['is_current_level'] ?? false,
    );
  }

  static Color getColorFromString(String text) {
    if (text.isEmpty) return Colors.transparent;
    final buffer = StringBuffer();
    if (text.length == 6 || text.length == 7) buffer.write('ff');
    buffer.write(text.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
