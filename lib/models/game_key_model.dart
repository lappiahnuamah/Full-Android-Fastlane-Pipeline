import 'package:equatable/equatable.dart';

class GameKeyModel extends Equatable {
  final int id;
  final String name;
  final int amount;
  final String icon;
  final bool isLocked;

  const GameKeyModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.icon,
    required this.isLocked,
  });

  factory GameKeyModel.fromJson(Map<String, dynamic> json) {
    return GameKeyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      amount: json['amount'] ?? "",
      icon: json['icon'] ?? "",
      isLocked: json['is_locked'] ?? true,
    );
  }

  @override
  List<Object?> get props => [id, name, amount, icon, isLocked];

  @override
  bool get stringify => true;
}
