import 'package:flutter/material.dart';

class LevelModel {
  int id;
  int user;
  String level;
  double totalPoints;
  bool isLocked;
  Color color;
  bool isActive;
//optional
  String? category;
  String? categoryName;
  String? gameType;
  String? gameTypeName;

  LevelModel({
    required this.id,
    required this.level,
    required this.totalPoints,
    required this.isLocked,
    required this.color,
    required this.user,
    required this.isActive,
    this.category,
    this.categoryName,
    this.gameType,
    this.gameTypeName,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
        id: json['id'] ?? 0,
        level: json['level'] ?? "",
        totalPoints: json['total_points'] ?? "",
        isLocked: json['is_locked'] ?? true,
        color: json['color'],
        user: json['user'],
        category: json['category'],
        categoryName: json['category_name'],
        gameType: json['game_type'],
        gameTypeName: json['game_type_name'],
        isActive: json['level'] == 'Beginner');
  }
}
