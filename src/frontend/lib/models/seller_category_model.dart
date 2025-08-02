class SellerCategoryModel {
  final String id;
  final String name;
  final String slug;
  final String description;

  SellerCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
  });

  // method to convert json to dart
  factory SellerCategoryModel.fromJson(Map<String, dynamic> json) {
    return SellerCategoryModel(
      id: json['_id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
    );
  }
}
