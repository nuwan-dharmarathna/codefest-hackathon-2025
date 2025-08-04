class SubCategoryModel {
  final String id;
  final String name;
  final String slug;
  final String category;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
  });

  // method to convert json to dart
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'],
      name: json['name'],
      slug: json['slug'],
      category: json['category'],
    );
  }
}
