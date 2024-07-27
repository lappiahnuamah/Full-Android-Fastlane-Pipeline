import 'package:savyminds/models/auth/app_user.dart';

class GameRankModel {
  int rank;
  int totalScore;
  AppUser? user;

  GameRankModel({required this.rank, required this.totalScore, this.user});

  factory GameRankModel.fromJson(Map<String, dynamic> json) {
    return GameRankModel(
        rank: json['rank'] ?? 0,
        totalScore: json['single_player_total_score'] ?? 0,
        user: json['user_account'] != null
            ? AppUser.fromUserDetails(json['user_account'])
            : null);
  }

  factory GameRankModel.fromMultiJson(Map<String, dynamic> json) {
    return GameRankModel(
        rank: json['rank'] ?? 0,
        totalScore: json['total_marks'] ?? 0,
        user: json['player'] != null
            ? AppUser.fromUserList(json['player'])
            : null);
  }

  factory GameRankModel.fromOverallMultiJson(Map<String, dynamic> json) {
    return GameRankModel(
        rank: json['rank'] ?? 0,
        totalScore: json['points'] ?? 0,
        user: json['player'] != null
            ? AppUser.fromUserList(json['player'])
            : null);
  }

  factory GameRankModel.fromMultiRankJson(Map<String, dynamic> json) {
    return GameRankModel(
        rank: json['rank'] ?? 0,
        totalScore: json['multi_player_total_score'] ?? 0,
        user: json['user_account'] != null
            ? AppUser.fromUserDetails(json['user_account'])
            : null);
  }
}

class GroupGameRankModel {
  GameRankModel currentGameRank;
  GameRankModel overallRank;

  GroupGameRankModel(
      {required this.currentGameRank, required this.overallRank});
}
