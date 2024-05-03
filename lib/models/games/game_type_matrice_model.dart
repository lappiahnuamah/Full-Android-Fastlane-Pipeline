import 'package:equatable/equatable.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/games/game_type_level_matric.dart';

class GameTypeMatric extends Equatable {
  final int id;
  final int gameType;
  final String gameTypeName;
  final String pointsMatrics;
  final String ttlMatrics;
  final List<GameTypeLevelMatric> levelMatrix;

  const GameTypeMatric({
    required this.id,
    required this.gameType,
    required this.gameTypeName,
    required this.pointsMatrics,
    required this.ttlMatrics,
    required this.levelMatrix,
  });

  factory GameTypeMatric.fromJson(Map<String, dynamic> json) {
    return GameTypeMatric(
      id: json['id'] ?? 0,
      gameType: json['game_type'] ?? 0,
      gameTypeName: json['game_type_name'] ?? "",
      pointsMatrics: json['points_matrics'] ?? "",
      ttlMatrics: json['ttl_matrics'] ?? "",
      levelMatrix: toGameTypeLevelMatric(json['level_matrix'] ?? []),
    );
  }

  static List<GameTypeLevelMatric> toGameTypeLevelMatric(List data) {
    try {
      List<GameTypeLevelMatric> gameTypeLevels = [];

      for (var d in data) {
        gameTypeLevels.add(GameTypeLevelMatric.fromJson(d));
      }

      return gameTypeLevels;
    } catch (e) {
      lg("Error  toGameTypeLevelMatric: $e");
      return [];
    }
  }

  List<Map<String, dynamic>> toGameTypeLevelMatricMap(
      List<GameTypeLevelMatric> data) {
    try {
      List<Map<String, dynamic>> options = [];

      for (var d in data) {
        options.add(d.toMap());
      }

      return options;
    } catch (e) {
      lg("Error  toGameTypeLevelMatricMao: $e");
      return [];
    }
  }

  toMap() {
    return {
      'id': id,
      'game_type': gameType,
      'game_type_name': gameTypeName,
      'points_matrics': pointsMatrics,
      'ttl_matrics': ttlMatrics,
      'level_matrix': toGameTypeLevelMatric(levelMatrix)
    };
  }

  @override
  List<Object?> get props => [id,gameType,gameTypeName,pointsMatrics,ttlMatrics,levelMatrix];

  @override
  bool get stringify =>
      true; // Enable toString() method for better debugging  "🇬🇭 +233(0) "
}


