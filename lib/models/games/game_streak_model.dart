// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

class GameStreakModel {
  int fiftyFifty;
  int goldenBadges;
  int swapQuestion;
  int freezeTime;
  int retakeQuestion;
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
    required this.swapQuestion,
    required this.freezeTime,
    required this.retakeQuestion,
  });

  factory GameStreakModel.fromJson(Map<String, dynamic> json) {
    return GameStreakModel(
      fiftyFifty: json['fifty_fifty_points'] ?? 0,
      goldenBadges: json['golden_badges'] ?? 0,
      totalPoints: json['total_single_player_points'] ?? 0,
      rank: json['single_player_rank'] ?? 0,
      overallGamePoints: json['overall_game_points'] ?? 0,
      multiPlayerRank: json['multiplayer_rank'] ?? 0,
      multiTotalPoints: json['total_multiplayer_points'] ?? 0,
      swapQuestion: json['swap_question'] ?? 0,
      freezeTime: json['freeze_time'] ?? 0,
      retakeQuestion: json['retake_question'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['fifty_fifty_points'] = fiftyFifty;
    data['golden_badges'] = goldenBadges;
    data['swap_question'] = swapQuestion;
    data['freeze_time'] = freezeTime;
    data['retake_question'] = retakeQuestion;

    return data;
  }

}
