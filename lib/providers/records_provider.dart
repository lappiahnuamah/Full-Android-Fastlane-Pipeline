import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/category_rank_model.dart';
import 'package:savyminds/models/solo_quest/game_type_rank_model.dart';

class RecordsProvider extends ChangeNotifier {
  List<CategoryRankModel> categoryRanks = [];
  List<GameTypeRankModel> soloQuestRanks = [];
  List<GameTypeRankModel> multiQuestRanks = [];

  bool categoryRanksIsLoading = true;
  bool soloQuestRankIsLoading = true;
  bool multiQuestRankIsLoading = true;

  setCategoryRanks(List<CategoryRankModel> catRanks) {
    categoryRanks = catRanks;
    categoryRanksIsLoading = false;
    notifyListeners();
  }

  setRanksIsLoading({required bool isLoading, required String gameType}) {
    switch (gameType) {
      case "Single Player":
        soloQuestRankIsLoading = isLoading;
        break;
      case "Multiplayer":
        multiQuestRankIsLoading = isLoading;
        lg(multiQuestRankIsLoading);
      default:
        categoryRanksIsLoading = isLoading;
    }
    notifyListeners(); 
  }

  //Solo Quest Ranks
  contestQuestRank(
      {required List<GameTypeRankModel> contestRanks,
      required String gameType}) {
    if (gameType == "Single Player") {
      soloQuestRanks = contestRanks;
      soloQuestRankIsLoading = false;
    }

    if (gameType == "Multiplayer") {
      multiQuestRanks = contestRanks;
      multiQuestRankIsLoading = false;
    }

    notifyListeners();
  }
}
