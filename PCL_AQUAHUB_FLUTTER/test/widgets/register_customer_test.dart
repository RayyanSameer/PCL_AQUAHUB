import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:pcl_aquahub/screens/register_customer_screen.dart';
import 'package:pcl_aquahub/providers/registration_provider.dart';
import 'package:pcl_aquahub/services/api_service.dart';

class FakeApiService implements ApiService {
  @override
  Future<String> registerCustomer(Map<String, dynamic> payload) async {
    return 'fake-user-id-123';
  }

  @override
  Future getHealth() async => throw UnimplementedError();

  @override
  Future vendorLogin(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future getVendorFleet(String vendorProfileId) {
    throw UnimplementedError();
  }

  @override
  Future getVendorOrders(String vendorProfileId) {
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('Register form submits and shows success', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<RegistrationProvider>(
        create: (_) => RegistrationProvider(FakeApiService()),
        child: const MaterialApp(home: RegisterCustomerScreen()),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'test@ex.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.enterText(find.byType(TextFormField).at(2), 'John');
    await tester.enterText(find.byType(TextFormField).at(4), '9999999999');
    await tester.enterText(find.byType(TextFormField).at(5), 'Street 1');
    await tester.enterText(find.byType(TextFormField).at(6), 'City');
    await tester.enterText(find.byType(TextFormField).at(7), 'State');
    await tester.enterText(find.byType(TextFormField).at(8), '560001');

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Registered:'), findsOneWidget);
  });
}
