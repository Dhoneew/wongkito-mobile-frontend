import 'package:flutter/material.dart';

import '../../features/dashboard/repositories/dashboard_repository.dart';
import '../../features/address/viewmodels/address_viewmodel.dart';
import '../../features/dashboard/viewmodels/dashboard_viewmodel.dart';
import '../../features/notification/viewmodels/notification_viewmodel.dart';
import '../../theme/wkm_style.dart';

import 'promo_detail_screen.dart';
import 'search_screen.dart';
import '../menu/menu_detail_screen.dart';
import '../menu/menu_screen.dart';
import '../notification/notification_screen.dart';
import '../orders/cart_screen.dart';
import '../../widgets/cart_icon.dart';
import '../../widgets/wkm_skeleton.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onOpenMenu;
  final ValueChanged<int>? onNavigateTab;

  /// Rekomendasi berasal dari data lokal; skeleton hanya dipakai saat caller
  /// sedang memuat data dari sumber awal.
  final bool isLoading;

  const DashboardScreen({
    super.key,
    this.onOpenMenu,
    this.onNavigateTab,
    this.isLoading = false,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color backgroundColor = WkmColors.background;
  static const Color textColor = WkmColors.dark;
  static const Color orange = WkmColors.orange;

  String selectedCategory = 'Semua';

  late final DashboardViewModel viewModel;

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    viewModel = DashboardViewModel(DashboardRepository());
    viewModel.addListener(_onViewModelChanged);
    NotificationViewModel.shared.loadNotifications();
    AddressViewModel.shared.loadAddresses();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                children: [
                  if (widget.isLoading)
                    const WkmBannerSkeleton()
                  else
                    _buildPromoBanner(context),
                  const SizedBox(height: 14),
                  _buildCategories(),
                  const SizedBox(height: 14),
                  _buildRecommendations(context),
                  _buildAiAssistant(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HEADER DAN PENCARIAN
  Widget _buildHeader(BuildContext context) {
    final addresses = AddressViewModel.shared.addresses;
    final primaryAddress = addresses.isEmpty
        ? null
        : addresses.firstWhere(
            (address) => address.isPrimary,
            orElse: () => addresses.first,
          );
    final locationLabel = primaryAddress?.fullAddress ?? 'Sawojajar';

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Warkop Wong Kito',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: textColor),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            locationLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              WkmCartIcon(
                icon: Icons.shopping_cart,
                color: textColor,
                size: 24,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              AnimatedBuilder(
                animation: NotificationViewModel.shared,
                builder: (context, _) {
                  final unread = NotificationViewModel.shared.unreadCount;
                  return IconButton(
                    tooltip: unread > 0 ? '$unread notifikasi belum dibaca' : 'Notifikasi',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(
                        onNavigateTab: widget.onNavigateTab,
                      ),
                        ),
                      );
                    },
                    icon: Badge(
                      isLabelVisible: unread > 0,
                      backgroundColor: orange,
                      label: Text(
                        unread > 9 ? '9+' : '$unread',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: textColor,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // SEARCH BAR (SESUAI GAMBAR)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: WkmColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Cari menu...',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: WkmColors.muted,
                      ),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: orange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BANNER PROMO (AYAM GEPREK)
  Widget _buildPromoBanner(BuildContext context) {
    return Container(
      height: 165,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/ayam_geprek.png', fit: BoxFit.cover),
          // Gradient halus bawah agar teks terbaca jelas seperti pada gambar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tag "PROMO HARI INI"
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PROMO HARI INI',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),

                // Teks Judul & Tombol Promo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paket Hemat Kenyang',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Kombinasi Es Jeruk + Ayam Geprek Sambal Matah Wong Kito.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PromoDetailScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Lihat Promo',
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
        ],
      ),
    );
  }

  // KATEGORI MENU
  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip('Semua'),
              _buildCategoryChip('Kopi'),
              _buildCategoryChip('Non-Kopi'),
              _buildCategoryChip('Makanan'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String title) {
    final isActive = viewModel.selectedCategory == title;

    return GestureDetector(
      onTap: () {
        viewModel.selectCategory(title);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? orange : WkmColors.border,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : textColor,
          ),
        ),
      ),
    );
  }

  // REKOMENDASI MENU
  Widget _buildRecommendations(BuildContext context) {
    // Kategori tanpa rekomendasi bukan error: jangan menyisakan judul dan
    // jarak kosong yang membuat halaman terasa berantakan.
    if (!widget.isLoading && viewModel.recommendedMenus.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Rekomendasi Untukmu',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            TextButton(
              onPressed: () {
                if (widget.onOpenMenu != null) {
                  widget.onOpenMenu!();
                  return;
                }
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(1);
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MenuScreen()),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: WkmColors.muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.isLoading)
          const WkmDashboardRecommendationSkeleton()
        else
        Row(
          children: viewModel.recommendedMenus.map((menu) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _buildMenuCard(
                  context: context,
                  image: menu.image,
                  name: menu.name,
                  price: wkmRupiah(menu.price),
                  description: menu.description,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  // KARTU MENU (SESUAI GAMBAR)
  Widget _buildMenuCard({
    required BuildContext context,
    required String image,
    required String name,
    required String price,
    required String description,
  }) {
    void openDetail() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MenuDetailScreen(
            menuName: name,
            menuPrice: price,
            menuImage: image,
            menuDescription: description,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: openDetail,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: WkmColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1.15,
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              price,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: openDetail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lihat Detail',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AI ASSISTANT
  Widget _buildAiAssistant(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MenuDetailScreen(
              menuName: 'Kopi Susu',
              menuPrice: 'Rp18.000',
              menuImage: 'assets/images/kopi_susu.png',
              menuDescription:
                  'Kopi espresso robusta + susu kental manis & gula aren',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: WkmColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.local_cafe, color: orange, size: 26),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rekomendasi Kopi Susu',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '8 dari 10 orang memesan Kopi Susu minggu ini. '
                    'Coba Kopi Susu gula aren favorit warkop.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: WkmColors.muted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: WkmColors.muted),
          ],
        ),
      ),
    );
  }
}
