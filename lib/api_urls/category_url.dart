import '../constants.dart';

class CategoryUrl {
  static const baseUrl = "$halloaBaseUrl/game/v1";
  static const categories = "$baseUrl/question-category/";
  static const categoryPoints = "$baseUrl/category-points/";
  static const favoriteCategories = "$baseUrl/question-category/get-favorites/";
  static getMyLevel(int id) => "$baseUrl/question-category/$id/get-my-level/";
}
