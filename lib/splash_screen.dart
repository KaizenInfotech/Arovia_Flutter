import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start initialization and navigation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    // All your existing initialization code moved here
    // await Firebase.initializeApp();
    // await requestNotificationPermissions();

    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getInt('isFirstLaunch') == 1;

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Decide where to go after splash
    final String initialRoute = isFirstLaunch ? '/dashboardscreen' : '/welcome';

    if (mounted) {
      Navigator.pushReplacementNamed(context, initialRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 246, 227, 1), // Same as WelcomeScreen
      body: Center(
        child: Image.asset(
          'assets/splash.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}