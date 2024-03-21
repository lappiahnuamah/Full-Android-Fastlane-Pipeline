import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:savyminds/resources/app_colors.dart';

class CategoryModel extends Equatable {
  final int id;
  final String name;
  final Color color;
  final int noOfQuestion;
  final String icon;
  final bool isLocked;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.noOfQuestion,
    required this.icon,
    required this.isLocked,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      color: _parseColor(json['color']),
      noOfQuestion: json['no_of_questions'] ?? 0,
      icon: json['icon'] ?? "",
      isLocked: json['is_locked'] ?? true,
    );
  }

  static Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', ''), radix: 16));
    } catch (e) {
      return AppColors.kPrimaryColor;
    }
  }

  @override
  List<Object?> get props => [id, name, color, noOfQuestion, icon, isLocked];

  @override
  bool get stringify => true; // Enable toString() method for better debugging
}
