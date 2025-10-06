import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const BeanRushApp());
}

class BeanRushApp extends StatelessWidget {
  const BeanRushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BeanRush',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF12D6B2),
        brightness: Brightness.dark,
      ),
      home: const WelcomeScreen(),
    );
  }
}
