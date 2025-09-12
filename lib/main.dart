import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'onboarding_screen.dart';
import 'auth_screen.dart';
import 'learning.dart';  // Import the learning path screen

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/splash", // The splash screen is the initial route
      routes: {
        "/splash": (context) => SplashScreen(),
        "/onboarding": (context) => OnboardingScreen(),
        "/auth": (context) => AuthScreen(),
        "/learning": (context) => LearningPage(), // Learning path screen
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
