import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../models/vendor_login_response.dart';

class VendorAuthProvider with ChangeNotifier {
  final ApiService service;
  final FlutterSecureStorage _secureStorage;

  VendorLoginResponse? _vendor;
  bool _isLoading = false;
  String? _error;
  String? _authToken;

  static const String _tokenKey = 'vendor_auth_token';
  static const String _vendorKey = 'vendor_profile';

  VendorAuthProvider(this.service, {FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  VendorLoginResponse? get vendor => _vendor;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get authToken => _authToken;
  bool get isAuthenticated => _authToken != null && _authToken!.isNotEmpty;

  /// Initialize auth state from secure storage (call during app startup).
  Future<void> initializeAuth() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) {
        _authToken = token;
        service.setAuthToken(token);
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to restore auth: $e';
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _vendor = await service.vendorLogin(email, password);
      // TODO: Extract token from response if available; for now, use vendor ID as placeholder token.
      _authToken = _vendor?.vendorProfileId ?? 'token_${DateTime.now().millisecondsSinceEpoch}';
      await _secureStorage.write(key: _tokenKey, value: _authToken!);
      service.setAuthToken(_authToken);
      return true;
    } catch (e) {
      _error = e.toString();
      _vendor = null;
      _authToken = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _vendor = null;
    _authToken = null;
    _error = null;
    await _secureStorage.delete(key: _tokenKey);
    service.setAuthToken(null);
    notifyListeners();
  }
