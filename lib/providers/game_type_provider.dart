import 'package:flutter/material.dart';
import 'package:savyminds/models/game_type_level_model.dart';

class GameTypeProvider extends ChangeNotifier {

    Map<int, GameTypelevelModel> categoryLevels = {};


    void setGameTypeLevel(int id, GameTypelevelModel level) {
        categoryLevels[id] = level;
        notifyListeners();
    }

    GameTypelevelModel getGameTypeLevel(int id) {
        return categoryLevels[id]!;
    }

}