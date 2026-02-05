import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/vendor_login_response.dart';

class VendorAuthProvider with ChangeNotifier {
  final ApiService service;

  VendorLoginResponse? _vendor;
  bool _isLoading = false;
  String? _error;

  VendorAuthProvider(this.service);

  VendorLoginResponse? get vendor => _vendor;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _vendor = await service.vendorLogin(email, password);
      return true;
    } catch (e) {
      _error = e.toString();
      _vendor = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
