import 'package:frontend/models/tender_model.dart';

class PriceTier {
  final double minQuantity;
  final double maxQuantity;
  final double price;
  final Units unit;

  PriceTier({
    required this.minQuantity,
    required this.maxQuantity,
    required this.price,
    required this.unit,
  });

  factory PriceTier.fromJson(Map<String, dynamic> json) {
    return PriceTier(
      minQuantity: json['minQuantity'].toDouble(),
      maxQuantity: json['maxQuantity'].toDouble(),
      price: json['price'].toDouble(),
      unit: unitsFromString(json['unit']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minQuantity': minQuantity,
      'maxQuantity': maxQuantity,
      'price': price,
      'unit': unitsToString(unit),
    };
  }
}

class AdvertisementModel {
  String? id;
  String? sellerId;
  String? categoryId;
  final String subCategoryId;
  final String name;
  final String description;
  final double quantity;
  final Units unit;
  final bool deliveryAvailable;
  final double? deliveryRadius;
  String? location;
  final List<PriceTier> priceTiers;
  List<String>? images;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isActive;

  AdvertisementModel({
    this.id,
    this.sellerId,
    this.categoryId,
    required this.subCategoryId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.deliveryAvailable,
    this.deliveryRadius,
    this.location,
    required this.priceTiers,
    this.images,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      id: json['_id'],
      sellerId: json['seller'],
      categoryId: json['category'],
      subCategoryId: json['subCategory'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'].toDouble(),
      unit: unitsFromString(json['unit']),
      deliveryAvailable: json['deliveryAvailable'],
      deliveryRadius: json['deliveryRadius']?.toDouble(),
      location: json['location'],
      priceTiers: List<PriceTier>.from(
        json['priceTiers'].map((x) => PriceTier.fromJson(x)),
      ),
      images: List<String>.from(json['images']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subCategory': subCategoryId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unit': unitsToString(unit),
      'deliveryAvailable': deliveryAvailable,
      'deliveryRadius': deliveryRadius,
      'priceTiers': priceTiers.map((x) => x.toJson()).toList(),
      'images': images,
    };
  }
}
