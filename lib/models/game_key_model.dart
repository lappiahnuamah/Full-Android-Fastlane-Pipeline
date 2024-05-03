import 'package:equatable/equatable.dart';
import 'package:savyminds/resources/app_enums.dart';

class GameKeyModel extends Equatable {
  final int id;
  final String name;
  final int amount;
  final String icon;
  final bool isLocked;
  final GameKeyType type;

  const GameKeyModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.icon,
    required this.isLocked,
    required this.type,
  });

  copyWith({
    int? id,
    String? name,
    int? amount,
    String? icon,
    bool? isLocked,
    GameKeyType? type,
  }) {
    return GameKeyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      icon: icon ?? this.icon,
      isLocked: isLocked ?? this.isLocked,
      type: type ?? this.type,
    );
  }

  factory GameKeyModel.fromJson(Map<String, dynamic> json) {
    return GameKeyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      amount: json['amount'] ?? "",
      icon: json['icon'] ?? "",
      isLocked: json['is_locked'] ?? true,
      type: GameKeyType.values[json['type'] ?? 0],
    );
  }

  

  @override
  List<Object?> get props => [id, name, amount, icon, isLocked];

  @override
  bool get stringify => true;
}
