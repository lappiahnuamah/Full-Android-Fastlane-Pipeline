import 'package:savyminds/models/level_model.dart';

class GameTypelevelModel {
  int id;
  int user;
  List<LevelModel> levels;
  double totalPoints;
  int gameType;
  String gameTypeName;

  GameTypelevelModel({
    required this.id,
    required this.levels,
    required this.totalPoints,
    required this.user,
    required this.gameType,
    required this.gameTypeName,
  });

  factory GameTypelevelModel.fromJson(Map<String, dynamic> json) {
    return GameTypelevelModel(
      id: json['category_points']?['id'] ?? 0,
      levels: ((json['levels'] ?? []) as List)
          .map((e) => LevelModel.fromJson(e))
          .toList(),
      totalPoints: (json['category_points']['total_points'] ?? 0).toDouble(),
      user: json['category_points']['user'] ?? 0,
      gameType: json['category_points']['game_type'] ?? 0,
      gameTypeName: json['category_points']?['game_type_name'],
    );
  }
}
