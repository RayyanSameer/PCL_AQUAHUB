import 'package:flutter/material.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const AquaHubApp());
}

class AquaHubApp extends StatelessWidget {
  const AquaHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PCL AquaHub',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'Poppins',
      ),
      home: const Scaffold(
        body: Center(child: Text('AquaHub Flutter App - scaffold')),
      ),
    );
  }
}
