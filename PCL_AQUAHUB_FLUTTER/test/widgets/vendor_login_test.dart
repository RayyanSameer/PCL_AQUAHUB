import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:pcl_aquahub/screens/vendor_login_screen.dart';
import 'package:pcl_aquahub/providers/vendor_auth_provider.dart';
import 'package:pcl_aquahub/services/api_service.dart';
import 'package:pcl_aquahub/models/vendor_login_response.dart';
import 'package:pcl_aquahub/screens/vendor_dashboard_screen.dart';
import 'package:pcl_aquahub/providers/vendor_dashboard_provider.dart';

class FakeApiService implements ApiService {
  @override
  Future vendorLogin(String email, String password) async {
    return VendorLoginResponse(vendorProfileId: 'vendor-1', userId: 'user-1', businessName: 'Acme', contactName: 'John', phone: '9999', email: email);
  }

  @override
  Future getHealth() async => throw UnimplementedError();

  @override
  Future getVendorFleet(String vendorProfileId) async => [];

  @override
  Future getVendorOrders(String vendorProfileId) async => [];

  @override
  Future registerCustomer(Map<String, dynamic> payload) {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('Vendor login navigates to dashboard', (tester) async {
    final fakeService = FakeApiService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<VendorAuthProvider>(create: (_) => VendorAuthProvider(fakeService)),
          ChangeNotifierProvider<VendorDashboardProvider>(create: (_) => VendorDashboardProvider(fakeService)),
        ],
        child: const MaterialApp(home: VendorLoginScreen()),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'vendor@ex.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'vendorpass');

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Should navigate to Dashboard screen
    expect(find.byType(VendorDashboardScreen), findsOneWidget);
    expect(find.text('Orders ('), findsOneWidget);
  });
}
