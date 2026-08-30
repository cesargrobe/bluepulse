import 'package:flutter/material.dart';

import 'screens/presentation_screen.dart';

class BluePulseApp extends StatelessWidget {
  const BluePulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    const oceanBlue = Color(0xFF075985);

    return MaterialApp(
      title: 'BluePulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: oceanBlue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F9FF),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const PresentationScreen(),
    );
  }
}
