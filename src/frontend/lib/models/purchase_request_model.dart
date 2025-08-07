import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';

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
  String? advertisement;
  String? buyerId;
  final double quantity;
  Units? unit;
  Status? status;
  String? rejectionStatus;
  double? pricePerUnit;
  double? totalPrice;
  Bool? wantToImportThem;
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

  factory PurchaseRequestModel.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestModel(
      id: json['_id'],
      advertisement: json['advertisement'],
      buyerId: json['buyer'],
      quantity: json['quantity'],
      unit: unitsFromString(json['unit']),
      status: statusFromString(json['status']),
      rejectionStatus: json['rejectionStatus'],
      pricePerUnit: json['pricePerUnit'],
      totalPrice: json['totalPrice'],
      wantToImportThem: json['wantToImportThem'],
      deliveryLocation: json['deliveryLocation'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'quantity': quantity, 'rejectionStatus': rejectionStatus};
  }

  String toJsonString() => json.encode(toJson());
}
