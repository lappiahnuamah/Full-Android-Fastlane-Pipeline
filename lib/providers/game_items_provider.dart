import 'package:flutter/material.dart';
import 'package:savyminds/models/game_key_model.dart';
import 'package:savyminds/models/games/game_streak_model.dart';
import 'package:savyminds/resources/app_enums.dart';

class GameItemsProvider extends ChangeNotifier {
  GameStreakModel gameStreaks = GameStreakModel(
      fiftyFifty: 0,
      goldenBadges: 0,
      totalPoints: 0,
      swapQuestion: 0,
      freezeTime: 0,
      retakeQuestion: 0,
      gamesPlayed: 0,
      streaks: 0);

  setUserStreaks(GameStreakModel streak) {
    gameStreaks = streak;
    notifyListeners();
  }

  List<GameKeyType> keyTypes = [
    GameKeyType.goldenKey,
    GameKeyType.fiftyFifty,
    GameKeyType.freezeTimeKey,
    GameKeyType.retakeKey,
    GameKeyType.swapKey
  ];

  Map<GameKeyType, GameKeyModel> userKeys = {
    GameKeyType.goldenKey: const GameKeyModel(
      id: 1,
      name: 'Golden Key',
      amount: 0,
      icon: 'assets/icons/game_keys/golden_key.svg',
      isLocked: false,
      type: GameKeyType.goldenKey,
    ),
    GameKeyType.fiftyFifty: const GameKeyModel(
      id: 1,
      name: 'Fifty fity Key',
      amount: 0,
      icon: 'assets/icons/game_keys/fifty_fifty.svg',
      isLocked: false,
      type: GameKeyType.fiftyFifty,
    ),
    GameKeyType.swapKey: const GameKeyModel(
      id: 1,
      name: 'Swap Key',
      amount: 10,
      icon: 'assets/icons/game_keys/swap_key.svg',
      isLocked: false,
      type: GameKeyType.swapKey,
    ),
    GameKeyType.freezeTimeKey: const GameKeyModel(
      id: 1,
      name: 'Freeze Time Key',
      amount: 0,
      icon: 'assets/icons/game_keys/freeze_time_key.svg',
      isLocked: false,
      type: GameKeyType.freezeTimeKey,
    ),
    GameKeyType.retakeKey: const GameKeyModel(
      id: 1,
      name: 'Retake Key',
      amount: 0,
      icon: 'assets/icons/game_keys/retake_key.svg',
      isLocked: false,
      type: GameKeyType.retakeKey,
    )
  };

  void addKey(GameKeyModel key) {
    userKeys[key.type] = key;
    notifyListeners();
  }

  void removeKey(GameKeyModel key) {
    userKeys.remove(key.type);
    notifyListeners();
  }

  void updateKey(GameKeyModel key) {
    userKeys[key.type] = key;
    notifyListeners();
  }

  reduceKeyAmount(GameKeyType keyType) {
    final key = userKeys[keyType];
    if (key != null) {
      final updatedKey = key.copyWith(amount: key.amount - 1);
      userKeys[keyType] = updatedKey;
    }
    notifyListeners();
  }

  increaseKeyAmount(GameKeyType keyType) {
    final key = userKeys[keyType];
    if (key != null) {
      final updatedKey = key.copyWith(amount: key.amount + 1);
      userKeys[keyType] = updatedKey;
    }
    notifyListeners();
  }

  setKeyAmount(GameKeyType keyType, int amount) {
    final key = userKeys[keyType];
    if (key != null) {
      final updatedKey = key.copyWith(amount: amount);
      userKeys[keyType] = updatedKey;
    }
    notifyListeners();
  }

  ////Set Key Items
  setKeyItems(GameStreakModel keys) {
    setKeyAmount(GameKeyType.fiftyFifty, keys.fiftyFifty);
    setKeyAmount(GameKeyType.goldenKey, keys.goldenBadges);
    setKeyAmount(GameKeyType.swapKey, keys.swapQuestion);
    setKeyAmount(GameKeyType.freezeTimeKey, keys.freezeTime);
    setKeyAmount(GameKeyType.retakeKey, keys.retakeQuestion);
    notifyListeners();
  }
}
