// lib/main.dart

import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => SplashScreen(),
        "/onboarding": (context) => OnboardingScreen(),
        "/home": (context) => HomeScreen(),
      },
      home: SplashScreen(),
    );
  }
}
