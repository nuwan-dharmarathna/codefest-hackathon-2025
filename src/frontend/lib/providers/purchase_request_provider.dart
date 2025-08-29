import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/models/purchase_request_model.dart';
import 'package:frontend/services/purchase_request_service.dart';

class PurchaseRequestProvider extends ChangeNotifier {
  final PurchaseRequestService _purchaseRequestService =
      PurchaseRequestService();

  List<PurchaseRequestModel> _purchaseRequests = [];
  PurchaseRequestModel? _selectedRequest;
  bool _isLoading = false;
  String? _error;

  List<PurchaseRequestModel> get purchaseRequests => _purchaseRequests;
  PurchaseRequestModel? get selectedRequest => _selectedRequest;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPurchaseRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _purchaseRequests = await _purchaseRequestService
          .fetchRequestsBasedOnSeller();
      _error = null;
      log("Fetch Purchase Requests : ${_purchaseRequests.length}");

      if (_purchaseRequests.isEmpty) {
        log('Note: Tenders list is empty after fetch');
      }
    } catch (e) {
      log('Error in fetch Requests: $e');
      _purchaseRequests = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPurchaseRequestsBasedOnAdvertisement(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _purchaseRequests = await _purchaseRequestService
          .fetchRequestsBasedOnAdvertisement(id);
      _error = null;
      log("Fetch Purchase Requests : ${_purchaseRequests.length}");

      if (_purchaseRequests.isEmpty) {
        log('Note: Tenders list is empty after fetch');
      }
    } catch (e) {
      log('Error in fetchTenders: $e');
      _purchaseRequests = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedRequest() {
    _selectedRequest = null;
    notifyListeners();
  }
}
