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
}
