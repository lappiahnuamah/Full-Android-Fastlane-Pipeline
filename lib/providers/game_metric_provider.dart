import 'package:flutter/material.dart';
import 'package:savyminds/models/games/game_type_matrice_model.dart';

class GameMetricsProvider extends ChangeNotifier {
  Map<int, GameTypeMatric> allMetric = {};

  addGameTypeMetric(GameTypeMatric gameTypeMatric) {
    allMetric.addAll({gameTypeMatric.gameType: gameTypeMatric});
    notifyListeners();
  }
}
