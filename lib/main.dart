import 'package:flutter/material.dart';
import 'package:project_pertama/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScentVault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C3D2E)),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(title: 'ScentVault'),
    );
  }
}
