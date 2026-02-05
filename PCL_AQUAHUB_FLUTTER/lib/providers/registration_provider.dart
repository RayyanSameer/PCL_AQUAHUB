import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class RegistrationProvider with ChangeNotifier {
  final ApiService service;
  bool _isLoading = false;
  String? _lastUserId;
  String? _error;

  RegistrationProvider(this.service);

  bool get isLoading => _isLoading;
  String? get lastUserId => _lastUserId;
  String? get error => _error;

  Future<bool> registerCustomer(Map<String, dynamic> payload) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final userId = await service.registerCustomer(payload);
      _lastUserId = userId;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
