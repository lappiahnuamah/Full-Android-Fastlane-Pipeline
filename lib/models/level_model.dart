import 'package:flutter/material.dart';

enum LevelName { beginner, intermediate, advanced, expert, elite }

class LevelModel {
  bool isLocked;
  Color color;
  LevelName name;
  bool isCurrentLevel;
  int lowerboundary;
  int upperboundary;

  LevelModel({
    required this.isCurrentLevel,
    required this.isLocked,
    required this.color,
    required this.name,
    this.lowerboundary = 0,
    this.upperboundary = 0,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      isLocked: json['is_locked'] ?? true,
      color: getColorFromString(json['color'] ?? ''),
      name: getLevelName(json['name'] ?? ''),
      isCurrentLevel: json['is_current_level'] ?? false,
      lowerboundary: json['lower_boundry'] ?? 0,
      upperboundary: json['upper_boundry'] ?? 0,
    );
  }

  static Color getColorFromString(String text) {
    if (text.isEmpty) return Colors.transparent;
    final buffer = StringBuffer();
    if (text.length == 6 || text.length == 7) buffer.write('ff');
    buffer.write(text.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static LevelName getLevelName(String name) {
    switch (name.toLowerCase()) {
      case 'beginner':
        return LevelName.beginner;
      case 'intermediate':
        return LevelName.intermediate;
      case 'advanced':
        return LevelName.advanced;
      case 'expert':
        return LevelName.expert;
      case 'elite':
        return LevelName.elite;
      default:
        return LevelName.beginner;
    }
  }
}

extension CapitalizeExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
