import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/models/games/start_game.dart';

class GameSession {
  int? id;
  int? user;
  String code;
  String title;
  List<AppUser> players;
  List<StartGameModel> games;
  DateTime? dateCreated;
  DateTime? lastUpdated;
  bool isCreator;

  GameSession(
      {this.id,
      required this.code,
      this.user,
      this.dateCreated,
      required this.games,
      this.lastUpdated,
      required this.players,
      required this.title,
      required this.isCreator});

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      user: json['user'],
      code: json['code'] ?? "Unknown",
      games: ((json['games'] ?? []) as List)
          .map((e) => StartGameModel.fromJson(e))
          .toList(),
      players: ((json['players'] ?? []) as List)
          .map((e) => AppUser.fromUserList(e))
          .toList(),
      dateCreated: DateTime.parse(json['date_created']),
      lastUpdated: DateTime.parse(json['last_updated']),
      isCreator: json['is_creator'] ?? false,
    );
  }
}
