import 'package:flutter/material.dart';

/// Shimmer satu arah yang lembut untuk placeholder skeleton.
///
/// Sengaja tidak berulang tanpa henti: cukup sekali bergerak saat skeleton
/// muncul, sehingga tidak membuang frame ketika Konten sudah tersedia.
class WkmShimmer extends StatelessWidget {
  final Widget child;

  const WkmShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1 + value * 2, 0),
              end: Alignment(-0.35 + value * 2, 0),
              colors: const [
                Color(0xFFE9E9E9),
                Color(0xFFF7F7F7),
                Color(0xFFE9E9E9),
              ],
              stops: const [0.2, 0.5, 0.8],
            ).createShader(bounds);
          },
          blendMode: BlendMode.modulate,
          child: child,
        );
      },
      child: child,
    );
  }
}

class WkmSkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const WkmSkeletonBox({
    super.key,
    this.width,
    this.height = 12,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton Detail Menu: mengikuti urutan konten asli agar tidak ada
/// layout jumping ketika data selesai dimuat.
class WkmMenuDetailSkeleton extends StatelessWidget {
  const WkmMenuDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const WkmShimmer(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WkmSkeletonBox(height: 200, radius: 12),
            SizedBox(height: 12),
            _SkeletonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WkmSkeletonBox(width: 190, height: 19),
                  SizedBox(height: 8),
                  WkmSkeletonBox(width: 110, height: 16),
                  SizedBox(height: 8),
                  WkmSkeletonBox(height: 11),
                  SizedBox(height: 6),
                  WkmSkeletonBox(width: 220, height: 11),
                ],
              ),
            ),
            SizedBox(height: 10),
            _SkeletonOptionSection(optionCount: 3),
            SizedBox(height: 10),
            _SkeletonOptionSection(optionCount: 2),
            SizedBox(height: 10),
            _SkeletonOptionSection(optionCount: 1),
            SizedBox(height: 10),
            _SkeletonOptionSection(optionCount: 2),
            SizedBox(height: 10),
            _SkeletonCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WkmSkeletonBox(width: 90, height: 14),
                  WkmSkeletonBox(width: 110, height: 42),
                ],
              ),
            ),
            SizedBox(height: 10),
            _SkeletonCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WkmSkeletonBox(width: 100, height: 12),
                  WkmSkeletonBox(width: 70, height: 14),
                ],
              ),
            ),
            SizedBox(height: 12),
            WkmSkeletonBox(height: 48, radius: 8),
            SizedBox(height: 16),
          ],
        ),
      ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final Widget child;

  const _SkeletonCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class _SkeletonOptionSection extends StatelessWidget {
  final int optionCount;

  const _SkeletonOptionSection({required this.optionCount});

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WkmSkeletonBox(width: 120, height: 13),
          const SizedBox(height: 10),
          for (var i = 0; i < optionCount; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            const WkmSkeletonBox(height: 46, radius: 8),
          ],
        ],
      ),
    );
  }
}

/// Skeleton kartu menu di halaman Menu Warkop.
class WkmMenuListSkeleton extends StatelessWidget {
  final int count;

  const WkmMenuListSkeleton({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return WkmShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, _) => _SkeletonCard(
          child: Row(
            children: [
              const WkmSkeletonBox(width: 74, height: 74, radius: 8),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    WkmSkeletonBox(height: 13),
                    SizedBox(height: 8),
                    WkmSkeletonBox(width: 80, height: 11),
                    SizedBox(height: 6),
                    WkmSkeletonBox(width: 120, height: 11),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton hasil pencarian: baris lebih pendek menyerupai kartu hasil Search.
class WkmSearchResultSkeleton extends StatelessWidget {
  final int count;

  const WkmSearchResultSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return WkmShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, _) => _SkeletonCard(
          child: Row(
            children: [
              const WkmSkeletonBox(width: 62, height: 62, radius: 8),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    WkmSkeletonBox(width: 150, height: 13),
                    SizedBox(height: 8),
                    WkmSkeletonBox(width: 90, height: 11),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton banner Dashboard mengikuti tinggi banner asli (165px).
class WkmBannerSkeleton extends StatelessWidget {
  const WkmBannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const WkmShimmer(
      child: WkmSkeletonBox(height: 165, radius: 12),
    );
  }
}

/// Skeleton rekomendasi Dashboard: kartu berbaris dengan rasio gambar sama.
class WkmDashboardRecommendationSkeleton extends StatelessWidget {
  const WkmDashboardRecommendationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return WkmShimmer(
      child: Row(
        children: [
          for (var i = 0; i < 2; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: _SkeletonCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    AspectRatio(
                      aspectRatio: 1.15,
                      child: WkmSkeletonBox(radius: 8),
                    ),
                    SizedBox(height: 8),
                    WkmSkeletonBox(height: 13),
                    SizedBox(height: 4),
                    WkmSkeletonBox(width: 70, height: 11),
                    SizedBox(height: 8),
                    WkmSkeletonBox(height: 36, radius: 8),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
