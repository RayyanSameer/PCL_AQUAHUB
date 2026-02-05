import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:pcl_aquahub/screens/health_screen.dart';
import 'package:pcl_aquahub/providers/api_provider.dart';
import 'package:pcl_aquahub/services/api_service.dart';
import 'package:pcl_aquahub/models/health.dart';

class FakeApiService implements ApiService {
  @override
  Future<HealthResponse> getHealth() async {
    return HealthResponse(status: 'ok', db: 'connected');
  }
}

void main() {
  testWidgets('HealthScreen shows OK after pressing button', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApiProvider>(
        create: (_) => ApiProvider(FakeApiService()),
        child: const MaterialApp(home: HealthScreen()),
      ),
    );

    // initial state
    expect(find.text('Status:'), findsNothing);

    // tap button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // start loading
    await tester.pump(const Duration(milliseconds: 100));

    // after async completes
    await tester.pumpAndSettle();

    expect(find.textContaining('Status: ok'), findsOneWidget);
    expect(find.textContaining('DB: connected'), findsOneWidget);
  });
}
