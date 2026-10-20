
import 'package:flutter/material.dart';

class WkmBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const WkmBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const orange = Color(0xFFFF6200);
  static const bgColor = Color(0xFFFAF9F9);

  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'Menu', 'Pesanan', 'Profil'];
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
          color: bgColor,
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

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with or without orange circle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: selected ? 48 : 32,
                      height: selected ? 48 : 32,
                      decoration: BoxDecoration(
                        color: selected ? orange : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          icons[index],
                          size: selected ? 26 : 26,
                          color: selected ? Colors.white : orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: selected ? orange : orange,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
