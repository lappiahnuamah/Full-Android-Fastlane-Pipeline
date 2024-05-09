import 'package:flutter/material.dart';
import 'package:savyminds/functions/games/game_matric_function.dart';
import 'package:savyminds/models/games/game_type_matrice_model.dart';

class GameMetricsProvider{

  GameTypeMatric? gameTypeMatric;

  setGameTypeMatric(GameTypeMatric? gameTypeMatric){
    gameTypeMatric = gameTypeMatric;
  }


}