import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';

class AudioProvider extends ChangeNotifier {
  bool _playBackgroundMusic = true;
  bool _playSoundEffects = true;

  bool get playBackgroundMusic => _playBackgroundMusic;
  bool get playSoundEffects => _playSoundEffects;

  toggleBackgroundMusic({bool? value}) {
    _playBackgroundMusic = value ?? !_playBackgroundMusic;
    notifyListeners();
    _playBackgroundMusic ? startGameBackgroundMusic() : stopBackgroundMusic();
    SharedPreferencesHelper.setBool(
        SharedPreferenceValues.settingsBackgroundMusic, _playBackgroundMusic);
  }

  toggleSoundEffects({bool? value}) {
    _playSoundEffects = value ?? !_playSoundEffects;
    notifyListeners();
    SharedPreferencesHelper.setBool(
        SharedPreferenceValues.settingsSoundEffect, _playSoundEffects);
  }

//
  setBackgroundMusic(bool value) {
    _playBackgroundMusic = value;
    notifyListeners();
    SharedPreferencesHelper.setBool(
        SharedPreferenceValues.settingsBackgroundMusic, value);
  }

//
  setSoundEffect(bool value) {
    _playSoundEffects = value;
    notifyListeners();
    SharedPreferencesHelper.setBool(
        SharedPreferenceValues.settingsSoundEffect, value);
  }

  //
  Future<bool> loadCachedAudioSettings() async {
    try {
      _playBackgroundMusic = await SharedPreferencesHelper.getBool(
              SharedPreferenceValues.settingsBackgroundMusic) ??
          true;
      _playSoundEffects = await SharedPreferencesHelper.getBool(
              SharedPreferenceValues.settingsSoundEffect) ??
          true;
      return true;
    } catch (e) {
      return false;
    }
  }

  //////////// Music Control //////
  ///
  startGameBackgroundMusic() {
    final defaultMusicPath = 'game_intro.mp3';
    if (_playBackgroundMusic) {
      FlameAudio.bgm.initialize();
      FlameAudio.bgm.play(defaultMusicPath, volume: 0.5);
    }
  }

  startAnyBackgroundMusic(String musicPath) {
    if (_playBackgroundMusic) {
      FlameAudio.bgm.play(musicPath, volume: 0.5);
    }
  }

  stopBackgroundMusic() {
    FlameAudio.bgm.stop();
  }

  ///
  ///
  Future<AudioPlayer?> startSoundEffect(String soundPath) async {
    if (_playSoundEffects) {
      return await FlameAudio.play(soundPath);
    }
    return null;
  }
}
