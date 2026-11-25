import 'package:flutter/material.dart';

import '../theme/wkm_style.dart';

class WkmBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const WkmBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Beranda', 'Menu', 'Pesanan', 'Profil'];
    const icons = [
      Icons.home_filled,
      Icons.restaurant_menu,
      Icons.receipt_long,
      Icons.person,
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: WkmColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(4, (index) {
            final selected = selectedIndex == index;
            final itemColor = selected ? WkmColors.orange : WkmColors.muted;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 68,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with or without orange circle
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: selected ? 48 : 32,
                        height: selected ? 48 : 32,
                        decoration: BoxDecoration(
                          color: selected
                              ? WkmColors.orange
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            icons[index],
                            size: 26,
                            color: selected ? Colors.white : WkmColors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: itemColor,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
