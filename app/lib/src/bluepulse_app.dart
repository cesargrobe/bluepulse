import 'package:flutter/material.dart';

import 'screens/presentation_screen.dart';
import 'storage/session_repository.dart';

class BluePulseApp extends StatelessWidget {
  const BluePulseApp({this.repository, super.key});

  final SessionStore? repository;

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
      home: PresentationScreen(repository: repository),
    );
  }
}
