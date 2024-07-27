import 'package:equatable/equatable.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/games/game_key_model.dart';

class GameTypeLevelMatric extends Equatable {
  final int id;
  final int gameLevel;
  final String gameLevelName;
  final int gameTypeMetrics;
  final String levelWeight;
  final int totalNumberOfQeustions;
  final int numberOfEasyQeustions;
  final int numberOfMediumQeustions;
  final int numberOfHardQeustions;
  final int levelUpperBoundry;
  final int levelLowerBoundry;
  final List<GameKeyModel> keyMetrics;

  const GameTypeLevelMatric({
    required this.id,
    required this.gameLevel,
    required this.gameLevelName,
    required this.gameTypeMetrics,
    required this.levelLowerBoundry,
    required this.levelUpperBoundry,
    required this.levelWeight,
    required this.numberOfEasyQeustions,
    required this.numberOfHardQeustions,
    required this.numberOfMediumQeustions,
    required this.totalNumberOfQeustions,
    required this.keyMetrics,
  });

  factory GameTypeLevelMatric.fromJson(Map<String, dynamic> json) {
    return GameTypeLevelMatric(
      id: json['id'] ?? 0,
      gameLevel: json['game_level'] ?? 0,
      gameTypeMetrics: json['game_type_metrics'] ?? 0,
      gameLevelName: json['game_level_name'] ?? "",
      levelWeight: json['level_weight'] ?? "",
      keyMetrics: toGameKey(json['key_matrics'] ?? []),
      totalNumberOfQeustions: json['total_number_of_qtns'] ?? 0,
      numberOfEasyQeustions: json['number_of_easy_qtns'] ?? 0,
      numberOfMediumQeustions: json['number_of_medium_qtns'] ?? 0,
      numberOfHardQeustions: json['number_of_hard_qtns'] ?? 0,
      levelLowerBoundry: json['level_lower_boundry'] ?? 0,
      levelUpperBoundry: json['level_upper_boundry'] ?? 0,
    );
  }

  static List<GameKeyModel> toGameKey(List data) {
    try {
      List<GameKeyModel> gameKeys = [];

      for (var d in data) {
        gameKeys.add(GameKeyModel.fromJson(d));
      }

      return gameKeys;
    } catch (e) {
      lg("Error  toGameKey: $e");
      return [];
    }
  }

  List<Map<String, dynamic>> toGameKeyMap(List<GameKeyModel> data) {
    try {
      List<Map<String, dynamic>> gameKaysMap = [];

      for (var d in data) {
        gameKaysMap.add(d.toMap());
      }

      return gameKaysMap;
    } catch (e) {
      lg("Error  toGameKeyMap: $e");
      return [];
    }
  }

  toMap() {
    return {
      'id': id,
      'game_level': gameLevel,
      'game_level_name': gameLevelName,
      'game_type_metrics': gameTypeMetrics,
      'level_weight': levelWeight,
      'total_number_of_qtns': totalNumberOfQeustions,
      'number_of_easy_qtns': numberOfEasyQeustions,
      'number_of_medium_qtns': numberOfMediumQeustions,
      'number_of_hard_qtns': numberOfHardQeustions,
      'level_lower_boundry': levelLowerBoundry,
      'level_upper_boundry': levelUpperBoundry,
      'key_metrics': toGameKey(keyMetrics),
    };
  }

  @override
  List<Object?> get props => [id, levelLowerBoundry, levelLowerBoundry];

  @override
  bool get stringify => true;
}
