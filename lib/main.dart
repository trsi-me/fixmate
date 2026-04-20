import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'widgets/app_theme.dart';

void main() {
  runApp(const FixMateApp());
}

class FixMateApp extends StatelessWidget {
  const FixMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixMate',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const WelcomeScreen(),
    );
  }
}
