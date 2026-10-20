import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'menu_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const Color backgroundColor = Color(0xFFFAF9F9);
  static const Color textColor = Color(0xFF1A1C1C);
  static const Color orange = Color(0xFFFF6200);

  int selectedCategory = 0;
  bool isError = true; // Shows empty/error state initially as requested
  bool isLoading = false;

  final List<String> categories = [
    'Semua (24)',
    'Kopi',
    'Non-Kopi',
    'Makanan',
  ];

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Kopi Susu',
      'description': 'Kopi espresso robusta + susu kental manis & gula aren',
      'price': 18000,
      'note': 'Estimasi saji: ~5 mnt',
      'category': 'Kopi',
      'image': 'assets/images/kopi_susu.png',
    },
    {
      'name': 'Matcha Latte',
      'description': 'Pure green tea matcha dengan fresh milk lembut',
      'price': 20000,
      'note': 'Bisa dingin / panas',
      'category': 'Non-Kopi',
      'image': 'assets/images/matcha_latte.png',
    },
    {
      'name': 'Pisang Goreng Keju',
      'description': 'Pisang kepok goreng renyah dengan taburan keju',
      'price': 15000,
      'note': 'Camilan hangat',
      'category': 'Makanan',
      'image': 'assets/images/ayam_geprek.png',
    },
  ];

  String formatRupiah(int price) {
    return 'Rp${price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  void _handleRetry() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() {
      isLoading = false;
      isError = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menu berhasil dimuat!'),
        backgroundColor: Color(0xFF2E7D32),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _checkConnection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Icon(Icons.wifi, color: orange, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status Koneksi Internet',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Wi-Fi / Data Seluler Terhubung',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Perangkat Anda terhubung ke internet. Jika menu belum tampil, server mungkin sedang sibuk.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleRetry();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Muat Ulang Sekarang',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      if (selectedCategory == 0) return true;
      return product['category'] == categories[selectedCategory];
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: isError
                  ? _buildEmptyErrorState()
                  : _buildLoadedMenu(filteredProducts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: textColor,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Menu Warkop',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          // Subtle toggle button to switch between empty state and loaded state for testing
          IconButton(
            tooltip: isError ? 'Tampilkan Menu' : 'Simulasi Menu Kosong',
            icon: Icon(
              isError ? Icons.refresh : Icons.cloud_off_outlined,
              size: 20,
              color: isError ? orange : const Color(0xFF888888),
            ),
            onPressed: () {
              setState(() {
                isError = !isError;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Empty & connection error state matching user's mockup screenshot
  Widget _buildEmptyErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom vector illustration of sad takeaway bag + wifi error
            const SizedBox(
              width: 190,
              height: 190,
              child: CustomPaint(
                painter: _MenuEmptyIllustrationPainter(),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Menu belum bisa dimuat',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Sepertinya koneksi sedang bermasalah.\nCoba muat ulang untuk melihat menu terbaru.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Color(0xFF757575),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),

            // Button 1: Coba Lagi (Solid orange pill button)
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _handleRetry,
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.refresh,
                        size: 18,
                        color: Colors.white,
                      ),
                label: Text(
                  isLoading ? 'Memuat...' : 'Coba Lagi',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Button 2: Periksa Koneksi (Text / borderless button)
            GestureDetector(
              onTap: _checkConnection,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Text(
                  'Periksa Koneksi',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: orange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Tips Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4E4CD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8D4BB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          size: 13,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Tips:',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A3B2C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pastikan koneksi internet stabil atau coba lagi beberapa saat.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Color(0xFF5D4E3E),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Loaded menu content with categories and product cards
  Widget _buildLoadedMenu(List<Map<String, dynamic>> filteredProducts) {
    return Column(
      children: [
        // Category Chips (No searchbar!)
        Container(
          height: 36,
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final selected = selectedCategory == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? orange : const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : textColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Product List
        Expanded(
          child: filteredProducts.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada produk di kategori ini',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Color(0xFF888888),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(filteredProducts[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuDetailScreen(
              menuName: product['name'] as String,
              menuPrice: formatRupiah(product['price'] as int),
              menuImage: product['image'] as String,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFE8E8E8),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product['image'] as String,
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        width: 78,
                        height: 78,
                        color: const Color(0xFFFFE0C2),
                        child: const Icon(
                          Icons.restaurant,
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product['name'] as String,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Tersedia',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['description'] as String,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          height: 1.4,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatRupiah(product['price'] as int),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    product['note'] as String,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${product['name']} ditambahkan ke pesanan',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      '+ Tambah',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Vector Painter matching the exact sad takeaway bag illustration in screenshot
class _MenuEmptyIllustrationPainter extends CustomPainter {
  const _MenuEmptyIllustrationPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.44;

    // 1. Soft beige circular background
    final bgPaint = Paint()
      ..color = const Color(0xFFF8ECDF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // 2. Decorative clouds / bubbles around circle
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    // Top left cloud
    canvas.drawCircle(Offset(size.width * 0.22, size.height * 0.28), 12, cloudPaint);
    canvas.drawCircle(Offset(size.width * 0.29, size.height * 0.24), 16, cloudPaint);
    canvas.drawCircle(Offset(size.width * 0.36, size.height * 0.27), 11, cloudPaint);

    // Top right cloud
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.30), 14, cloudPaint);
    canvas.drawCircle(Offset(size.width * 0.79, size.height * 0.33), 10, cloudPaint);

    // 3. Faint Disconnected Wi-Fi Icon above bag
    _drawDisconnectedWifi(canvas, Offset(size.width * 0.5, size.height * 0.22));

    // 4. Peeking items from bag: Coffee cup (left) & Bowl with steam (right)
    _drawPeekingItems(canvas, size);

    // 5. Orange Takeaway Paper Bag
    _drawBag(canvas, size);
  }

  void _drawDisconnectedWifi(Canvas canvas, Offset wifiCenter) {
    final wifiPaint = Paint()
      ..color = const Color(0xFFA89F95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Outer arc
    final rect1 = Rect.fromCircle(center: wifiCenter, radius: 18);
    canvas.drawArc(rect1, math.pi * 1.25, math.pi * 0.5, false, wifiPaint);

    // Middle arc
    final rect2 = Rect.fromCircle(center: wifiCenter, radius: 12);
    canvas.drawArc(rect2, math.pi * 1.25, math.pi * 0.5, false, wifiPaint);

    // Center dot / exclamation mark
    final dotPaint = Paint()
      ..color = const Color(0xFFA89F95)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(wifiCenter.dx, wifiCenter.dy + 3), 2.2, dotPaint);

    // Diagonal slash or disconnected cross
    final slashPaint = Paint()
      ..color = const Color(0xFFD32F2F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(wifiCenter.dx - 12, wifiCenter.dy - 12),
      Offset(wifiCenter.dx + 12, wifiCenter.dy + 8),
      slashPaint,
    );
  }

  void _drawPeekingItems(Canvas canvas, Size size) {
    // Drink Cup (Left side)
    final cupPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    final cupBorder = Paint()
      ..color = const Color(0xFFE0D7CE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cupRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.30, size.height * 0.35, 24, 30),
      const Radius.circular(4),
    );
    canvas.drawRRect(cupRect, cupPaint);
    canvas.drawRRect(cupRect, cupBorder);

    // Cup coffee content / sleeve
    final sleevePaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.30, size.height * 0.40, 24, 12),
      sleevePaint,
    );

    // Straw
    final strawPaint = Paint()
      ..color = const Color(0xFFFF6200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.36, size.height * 0.36),
      Offset(size.width * 0.32, size.height * 0.28),
      strawPaint,
    );

    // Bowl / Food box (Right side)
    final bowlPaint = Paint()
      ..color = const Color(0xFFFFF8E1)
      ..style = PaintingStyle.fill;
    final bowlBorder = Paint()
      ..color = const Color(0xFFFFD54F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final bowlRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.52, size.height * 0.37, 28, 22),
      const Radius.circular(6),
    );
    canvas.drawRRect(bowlRect, bowlPaint);
    canvas.drawRRect(bowlRect, bowlBorder);

    // Steam wavy lines
    final steamPaint = Paint()
      ..color = const Color(0xFFBCAAA4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final steam1 = Path()
      ..moveTo(size.width * 0.58, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.56,
        size.height * 0.32,
        size.width * 0.59,
        size.height * 0.29,
      );
    canvas.drawPath(steam1, steamPaint);

    final steam2 = Path()
      ..moveTo(size.width * 0.66, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.68,
        size.height * 0.32,
        size.width * 0.65,
        size.height * 0.29,
      );
    canvas.drawPath(steam2, steamPaint);
  }

  void _drawBag(Canvas canvas, Size size) {
    final bagPaint = Paint()
      ..color = const Color(0xFFFF6200)
      ..style = PaintingStyle.fill;

    final bagShadow = Paint()
      ..color = const Color(0xFFE65100)
      ..style = PaintingStyle.fill;

    // Trapezoid body of takeaway paper bag
    final bagLeft = size.width * 0.26;
    final bagRight = size.width * 0.74;
    final bagTop = size.height * 0.44;
    final bagBottom = size.height * 0.82;

    final bagPath = Path()
      ..moveTo(bagLeft + 6, bagTop)
      ..lineTo(bagRight - 6, bagTop)
      ..lineTo(bagRight, bagBottom - 6)
      ..quadraticBezierTo(bagRight, bagBottom, bagRight - 6, bagBottom)
      ..lineTo(bagLeft + 6, bagBottom)
      ..quadraticBezierTo(bagLeft, bagBottom, bagLeft, bagBottom - 6)
      ..close();

    canvas.drawPath(bagPath, bagPaint);

    // 3D side crease / shadow
    final creasePath = Path()
      ..moveTo(bagRight - 6, bagTop)
      ..lineTo(bagRight - 14, bagTop + 4)
      ..lineTo(bagRight - 12, bagBottom)
      ..lineTo(bagRight - 6, bagBottom)
      ..close();
    canvas.drawPath(creasePath, bagShadow);

    // Top folded border / rim of bag
    final rimPaint = Paint()
      ..color = const Color(0xFFFF7A24)
      ..style = PaintingStyle.fill;
    final rimRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bagLeft + 4, bagTop - 3, (bagRight - bagLeft) - 8, 8),
      const Radius.circular(3),
    );
    canvas.drawRRect(rimRect, rimPaint);

    // Oval handle cutout
    final handlePaint = Paint()
      ..color = const Color(0xFFD84315)
      ..style = PaintingStyle.fill;
    final handleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, bagTop + 14),
        width: 32,
        height: 10,
      ),
      const Radius.circular(5),
    );
    canvas.drawRRect(handleRect, handlePaint);

    // --- Cute Sad Face on Bag ---
    final facePaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final eyeCenterY = bagTop + 34;

    // Left eye: squinted / sad "<" shape
    final leftEye = Path()
      ..moveTo(size.width * 0.44, eyeCenterY - 4)
      ..lineTo(size.width * 0.39, eyeCenterY)
      ..lineTo(size.width * 0.44, eyeCenterY + 4);
    canvas.drawPath(leftEye, facePaint);

    // Right eye: sad closed curve
    final rightEye = Path()
      ..moveTo(size.width * 0.56, eyeCenterY + 2)
      ..quadraticBezierTo(
        size.width * 0.60,
        eyeCenterY - 4,
        size.width * 0.64,
        eyeCenterY + 2,
      );
    canvas.drawPath(rightEye, facePaint);

    // Rosy cheeks (peach/pink)
    final blushPaint = Paint()
      ..color = const Color(0xFFFFAB91).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.38, eyeCenterY + 8), 4.5, blushPaint);
    canvas.drawCircle(Offset(size.width * 0.64, eyeCenterY + 8), 4.5, blushPaint);

    // Mouth: Wavy squiggly sad frown "~"
    final mouthPath = Path()
      ..moveTo(size.width * 0.47, eyeCenterY + 14)
      ..quadraticBezierTo(
        size.width * 0.49,
        eyeCenterY + 11,
        size.width * 0.51,
        eyeCenterY + 14,
      )
      ..quadraticBezierTo(
        size.width * 0.53,
        eyeCenterY + 17,
        size.width * 0.55,
        eyeCenterY + 14,
      );
    canvas.drawPath(mouthPath, facePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
