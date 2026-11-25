import 'package:flutter/material.dart';

import '../data/order_store.dart';
import '../theme/wkm_style.dart';

/// Ikon keranjang bersama dengan badge jumlah item.
/// Badge mengikuti `OrderStore`, jadi langsung bertambah saat user menambah
/// menu dari Detail Menu tanpa perlu rebuild halaman secara manual.
class WkmCartIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final String tooltip;
  final VoidCallback onPressed;

  const WkmCartIcon({
    super.key,
    required this.onPressed,
    this.icon = Icons.shopping_cart_outlined,
    this.color = WkmColors.dark,
    this.size = 22,
    this.tooltip = 'Keranjang',
  });

  @override
  Widget build(BuildContext context) {
    final store = OrderStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final quantity = store.cartQuantity;

        return IconButton(
          tooltip: quantity > 0 ? '$tooltip ($quantity item)' : tooltip,
          onPressed: onPressed,
          icon: Badge(
            isLabelVisible: quantity > 0,
            label: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              switchInCurve: Curves.easeOut,
              child: Text(
                quantity > 99 ? '99+' : '$quantity',
                key: ValueKey<int>(quantity),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: WkmColors.orange,
            child: Icon(icon, size: size, color: color),
          ),
        );
      },
    );
  }
}
