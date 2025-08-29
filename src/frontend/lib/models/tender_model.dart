// models/tender.dart
import 'dart:convert';

import 'package:frontend/models/user_model.dart';

enum Units { kg, g, l, ml, unit, units }

String unitsToString(Units units) {
  switch (units) {
    case Units.kg:
      return 'kg';
    case Units.g:
      return 'g';
    case Units.l:
      return 'L';
    case Units.ml:
      return 'ml';
    case Units.unit:
      return 'unit';
    case Units.units:
      return 'units';
  }
}

Units unitsFromString(String unit) {
  switch (unit) {
    case 'kg':
      return Units.kg;
    case 'g':
      return Units.g;
    case 'L':
      return Units.l;
    case 'ml':
      return Units.ml;
    case 'unit':
      return Units.unit;
    case 'units':
      return Units.units;
    default:
      throw Exception('Invalid Unit');
  }
}

class TenderModel {
  String? id;
  String? createdBy;
  UserRole? role;
  final String title;
  final String description;
  final dynamic category;
  final dynamic subCategory;
  final double quantity;
  final Units unit;
  final bool deliveryRequired;
  String? deliveryLocation;
  bool? isClosed;
  String? acceptedBid;
  DateTime? createdAt;
  DateTime? updatedAt;

  TenderModel({
    this.id,
    this.createdBy,
    this.role,
    required this.title,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.quantity,
    required this.unit,
    required this.deliveryRequired,
    this.deliveryLocation,
    this.isClosed,
    this.acceptedBid,
    this.createdAt,
    this.updatedAt,
  });

  // Helper method to get category name
  String get categoryName {
    if (category is String) return category;
    if (category is Map<String, dynamic>) return category['name'] ?? '';
    return '';
  }

  // Helper method to get subcategory name
  String get subCategoryName {
    if (subCategory is String) return subCategory;
    if (subCategory is Map<String, dynamic>) return subCategory['name'] ?? '';
    return '';
  }

  factory TenderModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing tender: ${json['_id']}');

      return TenderModel(
        id: json['_id'] as String,
        createdBy: json['createdBy'] as String,
        role: userRoleFromString(json['role'] as String),
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'], // Can be Map or String
        subCategory: json['subCategory'], // Can be Map or String
        quantity: (json['quantity'] as num).toDouble(),
        unit: unitsFromString(json['unit'] as String),
        deliveryRequired: json['deliveryRequired'] as bool? ?? false,
        isClosed: json['isClosed'] as bool? ?? false,
        acceptedBid: json['acceptedBid'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
      );
    } catch (e) {
      print('Error parsing tender JSON: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'subCategory': subCategory,
      'quantity': quantity,
      'unit': unitsToString(unit),
      'deliveryRequired': deliveryRequired,
    };
  }

  String toJsonString() => json.encode(toJson());
}
