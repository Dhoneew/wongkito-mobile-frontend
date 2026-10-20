
import 'package:flutter/material.dart';
import '../login/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentPage = 0;

  final List<String> titles = [
    'Ngopi Jadi Lebih Mudah',
    'Pesan Tanpa Antre',
    'Pantau Pesananmu',
  ];

  final List<String> descriptions = [
    'Pesan makanan dan minuman favoritmu\n'
        'langsung dari Wong Kito Mobile',
    'Pilih menu, atur pesanan, dan\n'
        'langsung nikmati waktumu',
    'Lihat proses pesananmu sampai\n'
        'siap dinikmati',
  ];

  final List<String> images = [
    'assets/images/Onboarding1.png',
    'assets/images/Onboarding2.png',
    'assets/images/Onboarding3.png',
  ];

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void _nextPage() {
    if (currentPage < titles.length - 1) {
      setState(() {
        currentPage++;
      });
    } else {
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              Image.asset(
                'assets/images/Logo ada nama.png',
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(height: 100);
                },
              ),

              const SizedBox(height: 28),

              Text(
                titles[currentPage],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1C),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                descriptions[currentPage],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Color(0xFF1A1C1C),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: Image.asset(
                    images[currentPage],
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                        color: Color(0xFFD9D9D9),
                      );
                    },
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIndicator(currentPage == 0),
                  _buildIndicator(currentPage == 1),
                  _buildIndicator(currentPage == 2),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF79F1A),
                    foregroundColor: const Color(0xFFFAF9F9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: Text(
                    currentPage == 2
                        ? 'Mulai Sekarang'
                        : 'Selanjutnya',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: _goToLogin,
                child: const Text(
                  'Lewati',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFF1A1C1C),
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: active ? 20 : 7,
      height: 7,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFF79F1A)
            : const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
