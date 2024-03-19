// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

class GameStreakModel {
  int fiftyFifty;
  int goldenBadges;
  int totalPoints;
  int rank;
  int multiPlayerRank;
  int multiTotalPoints;
  int overallGamePoints;

  GameStreakModel({
    required this.fiftyFifty,
    required this.goldenBadges,
    required this.totalPoints,
    required this.rank,
    required this.multiPlayerRank,
    required this.multiTotalPoints,
    required this.overallGamePoints,
  });

  factory GameStreakModel.fromJson(Map<String, dynamic> json) {
    return GameStreakModel(
      fiftyFifty: json['fifty_fitfy_points'] ?? 0,
      goldenBadges: json['golden_badges'] ?? 0,
      totalPoints: json['total_single_player_points'] ?? 0,
      rank: json['single_player_rank'] ?? 0,
      overallGamePoints: json['overall_game_points'] ?? 0,
      multiPlayerRank: json['multiplayer_rank'] ?? 0,
      multiTotalPoints: json['total_multiplayer_points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['fifty_fitfy_points'] = fiftyFifty;
    data['golden_badges'] = goldenBadges;

    return data;
  }

//   {
//   "fifty_fifty_points": 0,
//   "golden_badges": 0,
//   "total_single_player_points": 0,
//   "single_player_rank": 1,
//   "total_multiplayer_points": 0,
//   "multiplayer_rank": 1,
//   "overall_game_points": 0
// }
}
