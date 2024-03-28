import 'package:flutter/material.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';

class SoloQuestProvider extends ChangeNotifier {
  List<QuestModel> _soloQuests = [];
  List<QuestModel> get soloQuests => _soloQuests;

  void addSoloQuests(List<QuestModel> quests) {
    _soloQuests.addAll(quests);
    notifyListeners();
  }

  void setSoloQuests(List<QuestModel> quests) {
    _soloQuests = quests;
    notifyListeners();
  }
}
