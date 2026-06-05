import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:project_pertama/login_page.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),

      debugShowCheckedModeBanner: false,
      title: 'ScentVault',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C3D2E),
        ),
        fontFamily: 'Roboto',
      ),

      home: const LoginPage(
        title: 'ScentVault',
      ),
    );
  }
}