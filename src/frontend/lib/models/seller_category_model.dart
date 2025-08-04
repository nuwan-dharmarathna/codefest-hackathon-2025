class SellerCategoryModel {
  final String id;
  final String name;
  final String nameOnBuyerSide;
  final String slug;
  final String imageOnSellerSide;
  final String imageOnBuyerSide;
  final String description;

  SellerCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageOnSellerSide,
    required this.imageOnBuyerSide,
    required this.description,
    required this.nameOnBuyerSide,
  });

  // method to convert json to dart
  factory SellerCategoryModel.fromJson(Map<String, dynamic> json) {
    return SellerCategoryModel(
      id: json['_id'],
      name: json['name'],
      nameOnBuyerSide: json['nameOnBuyerSide'],
      imageOnSellerSide: json['imageOnSellerSide'],
      imageOnBuyerSide: json['imageOnBuyerSide'],
      slug: json['slug'],
      description: json['description'],
    );
  }
}
