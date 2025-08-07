import 'package:flutter/material.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:frontend/services/tender_service.dart';

class TenderProvider extends ChangeNotifier {
  final TenderService _tenderService = TenderService();
  List<TenderModel> _tenders = [];
  TenderModel? _selectedTender;
  bool _isLoading = false;
  String? _error;

  List<TenderModel> get tenders => _tenders;
  TenderModel? get selectedTender => _selectedTender;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTenders({Map<String, dynamic>? queryParams}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tenders = await _tenderService.fetchAllTenders();
      _error = null;
    } catch (e) {
      _tenders = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTendersBasedOnSellerCategory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tenders = await _tenderService.fetchTendersBasedOnCategory();
      _error = null;
    } catch (e) {
      _tenders = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTenderById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedTender = await _tenderService.fetchTenderById(id);
      _error = null;
    } catch (e) {
      _selectedTender = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTender(TenderModel tender) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTender = await _tenderService.createTender(tender);
      _tenders.insert(0, newTender);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTender(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _tenderService.deleteTender(id);
      _tenders.removeWhere((t) => t.id == id);
      if (_selectedTender?.id == id) {
        _selectedTender = null;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptBid(String tenderId, String bidId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedTender = await _tenderService.acceptBid(bidId);
      final index = _tenders.indexWhere((t) => t.id == tenderId);
      if (index != -1) {
        _tenders[index] = updatedTender;
      }
      if (_selectedTender?.id == tenderId) {
        _selectedTender = updatedTender;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFilteredTenders({
    String? categoryId,
    String? subCategoryId,
  }) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> queryParams = {};
    if (categoryId != null) queryParams['category'] = categoryId;
    if (subCategoryId != null) queryParams['subCategory'] = subCategoryId;

    try {
      _tenders = await _tenderService.fetchTenders(queryParams: queryParams);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedTender() {
    _selectedTender = null;
    notifyListeners();
  }
}
