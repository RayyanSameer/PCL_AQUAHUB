import 'package:dio/dio.dart';
import '../models/health.dart';
import '../models/vendor_login_response.dart';
import '../models/order.dart';
import '../models/truck.dart';
import '../constants/api.dart';

abstract class ApiService {
  Future<HealthResponse> getHealth();

  /// Registers a customer. Returns the created userId on success.
  Future<String> registerCustomer(Map<String, dynamic> payload);

  /// Vendor login. Returns vendor profile details including `vendorProfileId`.
  Future<VendorLoginResponse> vendorLogin(String email, String password);

  /// Get vendor orders for a vendor profile id
  Future<List<Order>> getVendorOrders(String vendorProfileId);

  /// Get vendor fleet (trucks) for a vendor profile id
  Future<List<Truck>> getVendorFleet(String vendorProfileId);
}

class DioApiService implements ApiService {
  final Dio _dio;

  DioApiService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: kBackendBaseUrl, connectTimeout: 5000, receiveTimeout: 5000));

  @override
  Future<HealthResponse> getHealth() async {
    try {
      final resp = await _dio.get('/api/health');
      if (resp.statusCode == 200) {
        return HealthResponse.fromJson(resp.data as Map<String, dynamic>);
      }
      return HealthResponse(status: 'fail', db: resp.data is Map ? (resp.data['db']?.toString()) : null, error: resp.statusMessage);
    } on DioError catch (e) {
      String? msg;
      if (e.response != null && e.response?.data is Map) {
        msg = (e.response?.data as Map)['error']?.toString();
      }
      return HealthResponse(status: 'fail', error: msg ?? e.message);
    }
  }

  @override
  Future<String> registerCustomer(Map<String, dynamic> payload) async {
    try {
      final resp = await _dio.post('/api/register/customer', data: payload);
      if (resp.statusCode == 201 && resp.data is Map && resp.data['userId'] != null) {
        return resp.data['userId'].toString();
      }
      throw Exception('Failed to register customer: ${resp.statusMessage ?? resp.statusCode}');
    } on DioError catch (e) {
      String err = e.message;
      if (e.response != null && e.response?.data is Map) {
        err = (e.response?.data as Map)['error']?.toString() ?? err;
      }
      throw Exception(err);
    }
  }

  @override
  Future<VendorLoginResponse> vendorLogin(String email, String password) async {
    try {
      final resp = await _dio.post('/api/vendor/login', data: {'email': email, 'password': password});
      if (resp.statusCode == 200 && resp.data is Map && resp.data['vendor'] != null) {
        return VendorLoginResponse.fromJson(resp.data['vendor'] as Map<String, dynamic>);
      }
      throw Exception('Invalid credentials');
    } on DioError catch (e) {
      String err = e.message;
      if (e.response != null && e.response?.data is Map) {
        err = (e.response?.data as Map)['error']?.toString() ?? err;
      }
      throw Exception(err);
    }
  }

  @override
  Future<List<Order>> getVendorOrders(String vendorProfileId) async {
    try {
      final resp = await _dio.get('/api/vendor/$vendorProfileId/orders');
      if (resp.statusCode == 200 && resp.data is Map) {
        final items = resp.data['orders'] as List?;
        return (items ?? []).map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch orders');
    } on DioError catch (e) {
      String err = e.message;
      if (e.response != null && e.response?.data is Map) {
        err = (e.response?.data as Map)['error']?.toString() ?? err;
      }
      throw Exception(err);
    }
  }

  @override
  Future<List<Truck>> getVendorFleet(String vendorProfileId) async {
    try {
      final resp = await _dio.get('/api/vendor/$vendorProfileId/fleet');
      if (resp.statusCode == 200 && resp.data is Map) {
        final items = resp.data['trucks'] as List?;
        return (items ?? []).map((e) => Truck.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw Exception('Failed to fetch fleet');
    } on DioError catch (e) {
      String err = e.message;
      if (e.response != null && e.response?.data is Map) {
        err = (e.response?.data as Map)['error']?.toString() ?? err;
      }
      throw Exception(err);
    }
  }
}

