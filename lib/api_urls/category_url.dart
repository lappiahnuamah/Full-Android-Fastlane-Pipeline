import '../constants.dart';

class CategoryUrl {
  static const baseUrl = "$halloaBaseUrl/game/v1";
  static const categories = "$baseUrl/question-category/";
  static const categoryPoints = "$baseUrl/category-points/";
  static const categoryPointsRank = "${categoryPoints}get-my-rank/";
  static const listQuestions = "$baseUrl/list-questions/";
  static const gameMatrics = "$baseUrl/game-matrics/";
  static const favoriteCategories = "$baseUrl/question-category/get-favorites/";
  static getMyLevel(int? id) => "$baseUrl/question-category/$id/get-my-level/";
}
