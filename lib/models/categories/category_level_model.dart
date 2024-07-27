import 'dart:developer';

import 'package:savyminds/models/level_model.dart';

class CategoryLevelModel {
  int id;
  int user;
  List<LevelModel> levels;
  double totalPoints;
  int category;
  String categoryName;

  CategoryLevelModel({
    required this.id,
    required this.levels,
    required this.totalPoints,
    required this.user,
    required this.category,
    required this.categoryName,
  });

  factory CategoryLevelModel.fromJson(Map<String, dynamic> json) {
    log('category_points: ${json['category_points']}');
    return CategoryLevelModel(
      id: json['category_points']?['id'] ?? 0,
      levels: ((json['levels'] ?? []) as List)
          .map((e) => LevelModel.fromJson(e))
          .toList(),
      totalPoints: (json['category_points']['total_points'] ?? 0).toDouble(),
      user: json['category_points']['user'] ?? 0,
      category: json['category_points']['category'] ?? 0,
      categoryName: json['category_points']?['category_name'],
    );
  }

  static List<LevelModel> arrangeLevels(List<LevelModel> levels) {
    List<LevelModel> l = levels;

    for (var element in levels) {
      switch (element.name) {
        case LevelName.beginner:
          l[0] = element;
          break;
        case LevelName.intermediate:
          l[1] = element;
          break;
        case LevelName.advanced:
          l[2] = element;
          break;
        case LevelName.expert:
          l[3] = element;
          break;
        case LevelName.elite:
          l[4] = element;
          break;
        default:
      }
      // l.removeLast();
    }

    return l;
  }
}
