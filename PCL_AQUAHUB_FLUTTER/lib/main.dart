import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';

import 'services/api_service.dart';
import 'providers/api_provider.dart';
import 'providers/registration_provider.dart';
import 'providers/vendor_auth_provider.dart';
import 'providers/vendor_dashboard_provider.dart';
import 'screens/health_screen.dart';
import 'screens/register_customer_screen.dart';
import 'screens/vendor_login_screen.dart';

void main() {
  runApp(const AquaHubApp());
}

class AquaHubApp extends StatelessWidget {
  const AquaHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = DioApiService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApiProvider>(create: (_) => ApiProvider(apiService)),
        ChangeNotifierProvider<RegistrationProvider>(create: (_) => RegistrationProvider(apiService)),
        ChangeNotifierProvider<VendorAuthProvider>(create: (_) => VendorAuthProvider(apiService)),
        ChangeNotifierProvider<VendorDashboardProvider>(create: (_) => VendorDashboardProvider(apiService)),
      ],
      child: MaterialApp(
        title: 'PCL AquaHub',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          fontFamily: 'Poppins',
        ),
        home: const HealthScreen(),
        routes: {
          '/register': (_) => const RegisterCustomerScreen(),
          '/vendor-login': (_) => const VendorLoginScreen(),
        },
      ),
    );
  }
}
