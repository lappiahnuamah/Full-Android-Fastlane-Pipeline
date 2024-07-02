class CategoryRankModel {
  final int id;
  final int category;
  final String categoryName;
  final int numberOfPlays;
  final num totalPoints;
  final int rank;

  const CategoryRankModel({
    required this.id,
    required this.categoryName,
    required this.category,
    required this.numberOfPlays,
    required this.totalPoints,
    required this.rank,
  });

  factory CategoryRankModel.fromJson(Map<String, dynamic> json) {
    return CategoryRankModel(
      id: json['id'] ?? 0,
      category: json['category'] ?? 0,
      categoryName: json['category_name'],
      numberOfPlays: json['number_of_plays'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      rank: json['rank'] ?? 0,
    );
  }
}
