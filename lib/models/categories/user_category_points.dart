class UserCategoryPoint {
  int id;
  int user;
  double totalPoints;
  int category;
  String categoryName;

  UserCategoryPoint({
    required this.id,
    required this.totalPoints,
    required this.user,
    required this.category,
    required this.categoryName,
  });

  factory UserCategoryPoint.fromJson(Map<String, dynamic> json) {
    return UserCategoryPoint(
      id: json['id'] ?? 0,
      totalPoints: (json['total_points'] ?? 0).toDouble(),
      user: json['user'] ?? 0,
      category: json['category'] ?? 0,
      categoryName: json['category_name'],
    );
  }
}
