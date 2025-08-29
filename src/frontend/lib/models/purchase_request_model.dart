import 'dart:convert';

import 'package:frontend/models/tender_model.dart';

enum Status { pending, accepted, rejected, cancelled, paid }

String statusToString(Status status) {
  switch (status) {
    case Status.pending:
      return 'pending';
    case Status.accepted:
      return 'accepted';
    case Status.rejected:
      return 'rejected';
    case Status.cancelled:
      return 'cancelled';
    case Status.paid:
      return 'paid';
  }
}

Status statusFromString(String status) {
  switch (status) {
    case 'pending':
      return Status.pending;
    case 'accepted':
      return Status.accepted;
    case 'rejected':
      return Status.rejected;
    case 'cancelled':
      return Status.cancelled;
    case 'paid':
      return Status.paid;
    default:
      throw Exception('Invalid Status');
  }
}

class PurchaseRequestModel {
  String? id;
  dynamic advertisement;
  dynamic buyerId;
  final double quantity;
  Units? unit;
  Status? status;
  String? rejectionStatus;
  double? pricePerUnit;
  double? totalPrice;
  bool? wantToImportThem;
  String? deliveryLocation;
  DateTime? createdAt;

  PurchaseRequestModel({
    this.id,
    this.advertisement,
    this.buyerId,
    required this.quantity,
    this.unit,
    this.status,
    this.rejectionStatus,
    this.pricePerUnit,
    this.totalPrice,
    this.wantToImportThem,
    this.deliveryLocation,
    this.createdAt,
  });

  // Helper method to get Advertisement Name
  String get advertisementName {
    if (advertisement is String) return advertisement;
    if (advertisement is Map<String, dynamic>) return advertisement['name'];
    return '';
  }

  // Helper method to get Buyer Name
  String get buyerName {
    if (buyerId is String) return buyerId;
    if (buyerId is Map<String, dynamic>) {
      return buyerId['firstName'] + buyerId['lastName'];
    }
    return '';
  }

  factory PurchaseRequestModel.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestModel(
      id: json['_id'],
      advertisement: json['advertisement'],
      buyerId: json['buyer'],
      quantity: json['quantity'].toDouble(),
      unit: unitsFromString(json['unit']),
      status: statusFromString(json['status']),
      rejectionStatus: json['rejectionStatus'],
      pricePerUnit: json['pricePerUnit'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
      wantToImportThem: json['wantToImportThem'],
      deliveryLocation: json['deliveryLocation'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'quantity': quantity, 'rejectionStatus': rejectionStatus};
  }

  String toJsonString() => json.encode(toJson());
}
