import '../../features/menu/models/menu.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../features/menu/repositories/menu_repository.dart';
import '../../features/menu/viewmodels/menu_viewmodel.dart';
import '../../theme/wkm_style.dart';
import '../orders/cart_screen.dart';
import '../../widgets/cart_icon.dart';
import '../../widgets/wkm_skeleton.dart';
import 'menu_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  /// Saat dipakai sebagai tab utama, tombol back disembunyikan agar tidak
  /// mengarah ke Dashboard secara tidak terduga.
  final bool showBackButton;

  const MenuScreen({super.key, this.showBackButton = true});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final MenuViewModel viewModel;

  static const Color backgroundColor = WkmColors.background;
  static const Color textColor = WkmColors.dark;
  static const Color orange = WkmColors.orange;


  @override
  void initState() {
    super.initState();
    viewModel = MenuViewModel(MenuRepository());
    viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _handleRetry() async {
    await viewModel.retryMenu();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: orange, size: 17),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Katalog menu sudah diperbarui.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12),
              ),
            ),
          ],
        ),
        backgroundColor: WkmColors.dark,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Menu WKM adalah katalog demo lokal, jadi tidak ada pengecekan jaringan
  /// palsu. Sheet ini hanya memberi informasi dan aksi muat ulang nyata.
  void _showMenuInfo() {
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
                    color: WkmColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Icon(Icons.menu_book, color: orange, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Katalog Menu Demo',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Tersedia di perangkat',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: WkmColors.success,
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
                  'Menu WKM disimpan di aplikasi sehingga tidak memerlukan '
                  'koneksi internet pada demo ini. Bila tampilan perlu '
                  'disegarkan, gunakan tombol di bawah.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: WkmColors.muted,
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
                      'Muat Ulang Menu',
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
    final filteredProducts = viewModel.filteredMenus;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: viewModel.isError
                  ? _buildEmptyErrorState()
                  : viewModel.isLoading
                      ? const WkmMenuListSkeleton()
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
          if (widget.showBackButton) ...[
            wkmBackButton(() => Navigator.of(context).maybePop()),
            const SizedBox(width: 4),
          ],
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
          IconButton(
            tooltip: 'Info Menu',
            onPressed: _showMenuInfo,
            icon: const Icon(Icons.info_outline, size: 22, color: textColor),
          ),
          WkmCartIcon(
            icon: Icons.shopping_cart_outlined,
            size: 22,
            color: WkmColors.dark,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
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
                color: WkmColors.muted,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),

            // Button 1: Coba Lagi (Solid orange pill button)
            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: viewModel.isLoading ? null : _handleRetry,
                icon: const Icon(
                  Icons.refresh,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  viewModel.isLoading ? 'Memuat...' : 'Coba Lagi',
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

            // Button 2: Info katalog demo (bukan pengecekan jaringan palsu)
            GestureDetector(
              onTap: _showMenuInfo,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Text(
                  'Info Menu',
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

  /// Loaded menu content with viewModel.categories and product cards
  Widget _buildLoadedMenu(List<Menu> filteredProducts) {
    return Column(
      children: [
        // Category Chips (No searchbar!)
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            itemCount: viewModel.categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final selected = viewModel.selectedCategory == index;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  viewModel.selectCategory(index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? orange : WkmColors.border,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    '${viewModel.categories[index]} '
                    '(${viewModel.countForCategory(index)})',
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
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.restaurant_menu_outlined,
                          size: 40,
                          color: orange,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Belum ada menu di kategori ini',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Coba lihat semua menu yang tersedia.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: WkmColors.muted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 42,
                          child: OutlinedButton(
                            onPressed: () => viewModel.selectCategory(0),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: orange,
                              side: const BorderSide(color: orange),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Lihat Semua Menu'),
                          ),
                        ),
                      ],
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

  void _openDetail(Menu product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MenuDetailScreen(
          menuName: product.name,
          menuPrice: wkmRupiah(product.price),
          menuImage: product.image,
          menuDescription: product.description,
        ),
      ),
    );
  }

  Widget _buildProductCard(Menu product) {
    return GestureDetector(
      onTap: () => _openDetail(product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: WkmColors.border,
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
                    product.image,
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
                              product.name,
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
                              color: WkmColors.successSoft,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Tersedia',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: WkmColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          height: 1.4,
                          color: WkmColors.muted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        wkmRupiah(product.price),
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
                    product.note,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: WkmColors.muted,
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () => _openDetail(product),
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
      ..color = WkmColors.danger
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
      ..color = WkmColors.orange
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
      ..color = WkmColors.orange
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
