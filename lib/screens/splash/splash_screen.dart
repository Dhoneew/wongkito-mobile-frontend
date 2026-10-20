
import 'dart:async';
import 'package:flutter/material.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF79F1A),
      body: Center(
        child: Container(
          width: 112,
          height: 112,
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: Color(0xFFFAF9F9),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
  'assets/images/logo wong kito.png',
  fit: BoxFit.contain,
  errorBuilder: (context, error, stackTrace) {
    return const Icon(
      Icons.local_cafe,
      size: 65,
      color: Color(0xFFF79F1A),
    );
  },
),
        ),
      ),
    );
  }
}
