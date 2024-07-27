

import 'package:equatable/equatable.dart';

class ShortQuestionCategory extends Equatable {
  final int id;
  final String name;

  const ShortQuestionCategory({required this.id, required this.name});

  factory ShortQuestionCategory.fromJson(Map<String, dynamic> json) {
    return ShortQuestionCategory(
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
