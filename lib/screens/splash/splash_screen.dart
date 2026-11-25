import 'dart:async';

import 'package:flutter/material.dart';

import '../../features/auth/repositories/auth_repository.dart';
import '../../main.dart';
import '../../theme/wkm_style.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      // Simulasi sesi lokal: bila sudah login selama aplikasi berjalan,
      // langsung masuk dashboard. Jika tidak, tetap lewat onboarding.
      final alreadySignedIn = AuthRepository().currentUser != null;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => alreadySignedIn
              ? const MainNavigation()
              : const OnboardingPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WkmColors.orange,
      body: Center(
        child: Container(
          width: 112,
          height: 112,
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: WkmColors.background,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            'assets/images/logo wong kito.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.local_cafe,
                size: 65,
                color: WkmColors.orange,
              );
            },
          ),
        ),
      ),
    );
  }
}
