import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/health.dart';

class ApiProvider with ChangeNotifier {
  final ApiService service;

  ApiProvider(this.service);

  HealthResponse? _health;
  bool _isLoading = false;

  HealthResponse? get health => _health;
  bool get isLoading => _isLoading;

  Future<void> fetchHealth() async {
    _isLoading = true;
    notifyListeners();
    try {
      _health = await service.getHealth();
    } catch (e) {
      _health = HealthResponse(status: 'fail', error: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
