import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ MUST ADD THIS

import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => DatabaseService()),
      ],
      child: MaterialApp(
        title: 'PrepareED',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF21C573),
            primary: const Color(0xFF21C573),
          ),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

/// ✅ You forgot to include this!
/// AuthWrapper must be a StatefulWidget
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isSplashDone = false;
  bool _isOnboardingShown = false;

  @override
  void initState() {
    super.initState();
    _startAppFlow();
  }

  Future<void> _startAppFlow() async {
    // Step 1: Splash for 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isSplashDone = true);

    // Step 2: Check if onboarding was already shown
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isOnboardingShown = prefs.getBool('onboarding_complete') ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    // ✅ Splash screen first
    if (!_isSplashDone) return const SplashScreen();

    // ✅ Show onboarding only once
    if (!_isOnboardingShown) {
      return OnboardingScreen(
        onFinished: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('onboarding_complete', true);
          setState(() => _isOnboardingShown = true);
        },
      );
    }

    // ✅ If not logged in → show Auth Screen
    if (auth.currentUser == null) {
      return const AuthScreen();
    }

    // ✅ If user logged in → go to Home Page
    return const HomeScreen();
  }
}
