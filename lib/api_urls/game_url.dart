import '../constants.dart';

class GameUrl {
  static const baseUrl = "$halloaBaseUrl/game/v1";
  static const games = "$baseUrl/games/";
  static const option = "$baseUrl/option/";
  static const questions = "$baseUrl/questions/";
  static const uploadQuestion = "$baseUrl/upload-question/";
  static const submitAnswers = "$baseUrl/submit-answers/";
  static const joinsGame = "${games}join-game/";
  //static const gameRanking = "$baseUrl/players-rank/";
  static const singleGameRanking = "$baseUrl/single-players-rank/";
  static const multiGameRanking = "$baseUrl/multi-players-rank/";

  static const submitMultiplayerAnswer = "$baseUrl/submit-multiplayer-answer/";
  static const gameSession = "$baseUrl/game-session/";
  static const joinSession = "$baseUrl/game-session/join-session/";

  //type level
    static getGameTypeLevel(int id) => "$baseUrl/game-types/$id/get-my-level/";

}
