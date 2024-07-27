class GameStreakModel {
  int? id;
  int fiftyFifty;
  int goldenBadges;
  int swapQuestion;
  int freezeTime;
  int retakeQuestion;
  int totalPoints;

  int gamesPlayed;
  int streaks;

  GameStreakModel({
    this.id,
    required this.fiftyFifty,
    required this.goldenBadges,
    required this.totalPoints,
    required this.swapQuestion,
    required this.freezeTime,
    required this.retakeQuestion,
    required this.gamesPlayed,
    required this.streaks,
  });

  factory GameStreakModel.fromJson(Map<String, dynamic> json) {
    return GameStreakModel(
        fiftyFifty: json['fifty_fifty_points'] ?? 0,
        goldenBadges: json['golden_badges'] ?? 0,
        totalPoints: json['total_single_player_points'] ?? 0,
        swapQuestion: json['swap_question'] ?? 0,
        freezeTime: json['freeze_time'] ?? 0,
        retakeQuestion: json['retake_question'] ?? 0,
        id: json['id'],
        gamesPlayed: json['games_played'] ?? 0,
        streaks: json['streaks'] ?? 0);
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
