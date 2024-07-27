import 'package:flutter/material.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';

class ContestProvider extends ChangeNotifier {
  List<QuestModel> _contests = [];
  List<QuestModel> get contests => _contests;

  void addContests(List<QuestModel> quests) {
    _contests.addAll(quests);
    notifyListeners();
  }

  void setContests(List<QuestModel> quests) {
    _contests = quests;
    notifyListeners();
  }
}
