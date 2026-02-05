import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/order.dart';
import '../models/truck.dart';

class VendorDashboardProvider with ChangeNotifier {
  final ApiService service;
  bool _isLoading = false;
  List<Order> _orders = [];
  List<Truck> _trucks = [];
  String? _error;

  VendorDashboardProvider(this.service);

  bool get isLoading => _isLoading;
  List<Order> get orders => _orders;
  List<Truck> get trucks => _trucks;
  String? get error => _error;

  Future<void> fetchAll(String vendorProfileId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        service.getVendorOrders(vendorProfileId),
        service.getVendorFleet(vendorProfileId),
      ]);
      _orders = results[0] as List<Order>;
      _trucks = results[1] as List<Truck>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
