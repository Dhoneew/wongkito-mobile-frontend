
import 'package:flutter/material.dart';

class PromoDetailScreen extends StatelessWidget {
  const PromoDetailScreen({super.key});

  static const Color orange = Color(0xFFFF6200);
  static const Color bg = Color(0xFFFAF9F9);
  static const Color dark = Color(0xFF1A1C1C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar utama promo
                    SizedBox(
                      height: 260,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/Onboarding3.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: const Color(0xFFFFE0C2),
                                child: const Icon(
                                  Icons.restaurant,
                                  size: 80,
                                  color: orange,
                                ),
                              );
                            },
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.45),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.15),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 12,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 20,
                            left: 55,
                            child: Text(
                              'Detail Promo',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 12,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Informasi promo
                    Transform.translate(
                      offset: const Offset(0, -12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(
                          12, 12, 12, 20,
                        ),
                        decoration: const BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Paket Hemat Kenyang',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: dark,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Row(
                              children: [
                                const Text(
                                  'Rp25.000',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: orange,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Rp32.000',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: Colors.grey,
                                    decoration:
                                        TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDADA),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '22%',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            _buildProduct(
                              image: 'assets/images/Onboarding1.png',
                              name: 'Es Jeruk',
                              description: '1 gelas',
                            ),

                            _buildProduct(
                              image: 'assets/images/Onboarding3.png',
                              name: 'Ayam Geprek',
                              description: '1 porsi',
                            ),

                            _buildProduct(
                              image: 'assets/images/Onboarding3.png',
                              name: 'Sambal Matah',
                              description: 'Pelengkap paket',
                            ),

                            const SizedBox(height: 12),

                            const Row(
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  size: 13,
                                  color: orange,
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Promo berlaku hingga 30 September 2026',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Promo dipilih! '
                                          'Fitur pemesanan belum terhubung.',
                                        ),
                                      ),
                                    );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: orange,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  'Ambil Promo',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduct({
    required String image,
    required String name,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFE3E3E3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              image,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 54,
                  height: 54,
                  color: const Color(0xFFFFE0C2),
                  child: const Icon(
                    Icons.fastfood,
                    color: orange,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: dark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}