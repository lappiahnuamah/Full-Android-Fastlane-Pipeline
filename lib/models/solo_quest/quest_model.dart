import 'package:equatable/equatable.dart';

class QuestModel extends Equatable {
  final int id;
  final String name;
  final String subtitle;
  final String description;
  final String icon;
  final bool isLocked;
  final String mode;

  const QuestModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isLocked,
    required this.subtitle,
    required this.mode,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      icon: json['icon'] ?? "",
      isLocked: json['is_locked'] ?? true,
      subtitle: json['subtitle'] ?? "",
      mode: json['mode'] ?? "",
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, icon, isLocked, subtitle, mode];

  @override
  bool get stringify =>
      true; // Enable toString() method for better debugging  "🇬🇭 +233(0) "
}
