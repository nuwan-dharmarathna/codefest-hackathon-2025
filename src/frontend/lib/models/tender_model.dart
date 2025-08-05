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
  final String id;
  final String createdBy;
  final UserRole role;
  final String title;
  final String description;
  final String category;
  final String? subCategory;
  final double quantity;
  final Units unit;
  final bool deliveryRequired;
  final String? deliveryLocation;
  final bool isClosed;
  final String? acceptedBid;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TenderModel({
    required this.id,
    required this.createdBy,
    required this.role,
    required this.title,
    required this.description,
    required this.category,
    this.subCategory,
    required this.quantity,
    required this.unit,
    required this.deliveryRequired,
    this.deliveryLocation,
    required this.isClosed,
    this.acceptedBid,
    required this.createdAt,
    this.updatedAt,
  });

  factory TenderModel.fromJson(Map<String, dynamic> json) {
    return TenderModel(
      id: json['_id'],
      createdBy: json['createdBy'],
      role: userRoleFromString(json['role']),
      title: json['title'],
      description: json['description'],
      category: json['category'],
      subCategory: json['subCategory'],
      quantity: json['quantity']?.toDouble() ?? 0.0,
      unit: unitsFromString(json['unit']),
      deliveryRequired: json['deliveryRequired'] ?? false,
      deliveryLocation: json['deliveryLocation'],
      isClosed: json['isClosed'] ?? false,
      acceptedBid: json['acceptedBid'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdBy': createdBy,
      'role': userRoletoString(role),
      'title': title,
      'description': description,
      'category': category,
      'subCategory': subCategory,
      'quantity': quantity,
      'unit': unitsToString(unit),
      'deliveryRequired': deliveryRequired,
      'deliveryLocation': deliveryLocation,
      'isClosed': isClosed,
      'acceptedBid': acceptedBid,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String toJsonString() => json.encode(toJson());
}
