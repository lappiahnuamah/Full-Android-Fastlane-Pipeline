class GameTypeRankModel {
  final int id;
  final int gameType;
  final String gameTypeName;
  final int numberOfPlays;
  final num totalPoints;
  final int rank;
  final String level;

  const GameTypeRankModel({
    required this.id,
    required this.gameTypeName,
    required this.gameType,
    required this.numberOfPlays,
    required this.totalPoints,
    required this.rank,
    required this.level,
  });

  factory GameTypeRankModel.fromJson(Map<String, dynamic> json) {
    return GameTypeRankModel(
      id: json['id'] ?? 0,
      gameType: json['game_type'] ?? 0,
      gameTypeName: json['game_type_name'] ?? '',
      numberOfPlays: json['number_of_plays'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      rank: json['rank'] ?? 0,
      level: json['level'],
    );
  }
}
