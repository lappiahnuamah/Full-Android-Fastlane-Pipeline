

import 'package:equatable/equatable.dart';

class GameKeyModel extends Equatable {
  final int id;
  final String name;

  const GameKeyModel({required this.id, required this.name});

  factory GameKeyModel.fromJson(Map<String, dynamic> json) {
    return GameKeyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  toMap() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];

  @override
  bool get stringify => true;
}
