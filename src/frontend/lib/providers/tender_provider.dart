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

  Future<void> fetchTenders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Starting to fetch tenders...');
      final fetchedTenders = await _tenderService.fetchAllTenders();
      print('Successfully fetched ${fetchedTenders.length} tenders');

      _tenders = fetchedTenders;
      _error = null;

      if (_tenders.isEmpty) {
        print('Note: Tenders list is empty after fetch');
      }
    } catch (e) {
      print('Error in fetchTenders: $e');
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

  Future<Map<String, dynamic>> createTender(TenderModel tender) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTender = await _tenderService.createTender(tender);

      if (newTender['status'] == 'success') {
        return newTender;
      }
      return {
        'status': 'failed',
        'error':
            newTender['error'] ??
            {
              'statusCode': 400,
              'message': newTender['message'] ?? 'Registration failed',
            },
        'message': newTender['message'] ?? 'Registration failed',
      };
    } catch (e) {
      _error = e.toString();
      return {
        'status': 'failed',
        'error': {'statusCode': 500, 'message': 'Network error'},
        'message': 'Failed to connect to server',
      };
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
