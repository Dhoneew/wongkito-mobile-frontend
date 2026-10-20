
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

  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'Menu', 'Pesanan', 'Profil'];
    const icons = [
      Icons.home_filled,
      Icons.restaurant,
      Icons.receipt_long,
      Icons.person,
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 64,
        color: const Color(0xFFFAF9F9),
        child: Row(
          children: List.generate(4, (index) {
            final selected = selectedIndex == index;

            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[index],
                      size: 23,
                      color: selected ? orange : Colors.grey,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: selected ? orange : Colors.grey,
                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
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
