import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement_model.dart';
import 'package:frontend/services/advertisement_service.dart';

class AdvertisementProvider extends ChangeNotifier {
  final AdvertisementService _advertisementService = AdvertisementService();
  List<AdvertisementModel> _advertisements = [];
  AdvertisementModel? _currentAdvertisement;
  bool _isLoading = false;
  String? _error;

  List<AdvertisementModel> get advertisements => _advertisements;
  AdvertisementModel? get currentAdvertisement => _currentAdvertisement;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAdvertisements() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _advertisements = await _advertisementService.fetchAllAdvertisements();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAdvertisementById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentAdvertisement = await _advertisementService
          .fetchAdvertisementById(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createAdvertisement(
    AdvertisementModel advertisement,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newAd = await _advertisementService.createAdvertisement(
        advertisement,
      );

      if (newAd['status'] == 'success') {
        return newAd;
      }

      return {
        'status': 'failed',
        'error':
            newAd['error'] ??
            {
              'statusCode': 400,
              'message': newAd['message'] ?? 'Registration failed',
            },
        'message': newAd['message'] ?? 'Registration failed',
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

  Future<void> deleteAdvertisement(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _advertisementService.deleteAdvertisement(id);
      _advertisements.removeWhere((ad) => ad.id == id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
