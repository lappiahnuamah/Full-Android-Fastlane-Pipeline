import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LevelModel extends Equatable {
  final int id;
  final String name;
  final bool active;
  final double progress;
  final bool isLocked;
  final Color color;

  const LevelModel(
      {required this.id,
      required this.name,
      required this.active,
      required this.progress,
      required this.isLocked,
      required this.color});

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? "",
        active: json['active'] ?? "",
        progress: json['progress'] ?? "",
        isLocked: json['is_locked'] ?? true,
        color: json['color']);
  }

  @override
  List<Object?> get props => [id, name, active, progress, isLocked];

  @override
  bool get stringify => true;
}
