import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/screens/welcome_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MindOverMedsApp(),
    ),
  );
}

class MindOverMedsApp extends StatelessWidget {
  const MindOverMedsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Over Meds',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
