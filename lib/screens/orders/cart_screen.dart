import 'package:flutter/material.dart';

import '../../data/order_store.dart';
import '../../features/orders/models/cart_item.dart';
import '../../main.dart';
import '../../theme/wkm_style.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color orange = WkmColors.orange;
  static const Color primaryOrange = WkmColors.orange;
  static const Color bg = WkmColors.background;
  static const Color dark = WkmColors.dark;
  static const Color muted = WkmColors.muted;
  static const Color softOrange = WkmColors.softOrange;
  static const Color borderColor = WkmColors.border;

  final OrderStore store = OrderStore.instance;

  Future<void> _confirmRemoveItem(CartItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          'Hapus Item?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
        content: Text(
          '${item.menuName} akan dihapus dari keranjang.',
          style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: dark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Batal', style: TextStyle(color: muted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: WkmColors.danger,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    store.removeItem(item);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.menuName} dihapus dari keranjang'),
          backgroundColor: WkmColors.dark,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Urungkan',
            textColor: orange,
            onPressed: () {
              // Jangan menggandakan item jika sudah dikembalikan lewat aksi lain.
              if (!store.cart.contains(item)) store.addItem(item);
            },
          ),
        ),
      );
  }

  void _decrementQuantity(CartItem item) {
    if (item.quantity <= 1) {
      _confirmRemoveItem(item);
      return;
    }
    store.updateQuantity(item, item.quantity - 1);
  }

  Future<void> _editItemNote(CartItem item) async {
    final controller = TextEditingController(text: item.note);
    final updatedNote = await showDialog<String>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text(
            'Catatan Item',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLines: 2,
            autofocus: true,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: dark),
            decoration: InputDecoration(
              hintText: 'Contoh: es sedikit, gula dipisah...',
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: WkmColors.hint,
              ),
              filled: true,
              fillColor: bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: borderColor),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Batal', style: TextStyle(fontFamily: 'Inter', color: muted)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogCtx, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Simpan', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
    controller.dispose();

    if (updatedNote != null) {
      store.updateItemNote(item, updatedNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final isEmpty = store.cart.isEmpty;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: dark,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.chevron_left, size: 28, color: dark),
              onPressed: () => Navigator.pop(context),
            ),
            titleSpacing: 0,
            title: Text(
              isEmpty ? 'Keranjang' : 'Keranjang (${store.cartQuantity} Item)',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: dark,
              ),
            ),
          ),
          body: isEmpty
              ? _buildEmptyCartView()
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        children: [
                          ...store.cart.map(_buildCartItem),
                          const SizedBox(height: 8),
                          _buildSummaryCard(),
                        ],
                      ),
                    ),
                    _buildBottomBar(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item.menuImage,
                  width: 80,
                  height: 84,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 80,
                    height: 84,
                    color: softOrange,
                    child: const Icon(Icons.local_cafe, color: orange, size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.menuName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.temperature}, ${item.sugarLevel}'
                      '${item.extraShot ? ', Extra Shot (+Rp5.000)' : ''}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _editItemNote(item),
                      child: Row(
                        children: [
                          const Icon(Icons.edit_note, size: 15, color: orange),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.note.isEmpty
                                  ? 'Tambah catatan item'
                                  : 'Catatan: ${item.note}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: item.note.isEmpty ? orange : dark,
                                fontStyle: item.note.isEmpty
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${wkmRupiah(item.price)} / item',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Subtotal ${wkmRupiah(item.subtotal)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: borderColor),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _confirmRemoveItem(item),
                icon: const Icon(Icons.delete_outline, size: 17),
                label: const Text('Hapus'),
                style: TextButton.styleFrom(
                  foregroundColor: WkmColors.danger,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              _quantityButton(
                Icons.remove,
                () => _decrementQuantity(item),
              ),
              Container(
                width: 38,
                height: 34,
                alignment: Alignment.center,
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: dark,
                  ),
                ),
              ),
              _quantityButton(
                Icons.add,
                () => store.updateQuantity(item, item.quantity + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: softOrange,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 17, color: primaryOrange),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Keranjang',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: dark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal (${store.cartQuantity} item)',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: muted),
              ),
              Text(
                wkmRupiah(store.cartTotal),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: borderColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Sementara',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),
              Text(
                wkmRupiah(store.cartTotal),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: primaryOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final canProceed = store.cart.isNotEmpty;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: borderColor)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrange,
              disabledBackgroundColor: WkmColors.disabled,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: canProceed
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  }
                : null,
            child: Text(
              'Lanjut Checkout',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCartView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 210,
              height: 210,
              child: CustomPaint(painter: _EmptyCartPainter()),
            ),
            const SizedBox(height: 18),
            const Text(
              'Keranjangmu masih kosong',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Yuk pilih makanan dan minuman favoritmu\nuntuk mulai memesan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: WkmColors.muted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: 190,
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigation(initialIndex: 1),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.restaurant, size: 16),
                label: const Text(
                  'Mulai Belanja',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 190,
              height: 40,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavigation(initialIndex: 0),
                    ),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryOrange, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lihat Promo',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor, width: 0.8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.035),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

class _EmptyCartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final bgPaint = Paint()..color = const Color(0xFFF7EFE6);
    canvas.drawCircle(Offset(cx, cy + 8), 86, bgPaint);

    final sparklePaint = Paint()..color = const Color(0xFFFFB74D);
    canvas.drawCircle(Offset(cx - 72, cy - 28), 3, sparklePaint);
    canvas.drawCircle(Offset(cx + 68, cy - 18), 3.5, sparklePaint);
    canvas.drawCircle(Offset(cx + 58, cy + 56), 2.5, sparklePaint);

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 66), width: 112, height: 14),
      shadowPaint,
    );

    final cartStroke = Paint()
      ..color = WkmColors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final basketFill = Paint()..color = const Color(0xFFFFB74D);

    final basketPath = Path()
      ..moveTo(cx - 40, cy - 12)
      ..lineTo(cx + 42, cy - 12)
      ..lineTo(cx + 32, cy + 36)
      ..lineTo(cx - 32, cy + 36)
      ..close();
    canvas.drawPath(basketPath, basketFill);
    canvas.drawPath(basketPath, cartStroke);

    final handlePath = Path()
      ..moveTo(cx - 56, cy - 26)
      ..lineTo(cx - 44, cy - 26)
      ..lineTo(cx - 32, cy + 36)
      ..lineTo(cx + 32, cy + 36);
    canvas.drawPath(handlePath, cartStroke);

    final wheelPaint = Paint()..color = WkmColors.dark;
    canvas.drawCircle(Offset(cx - 20, cy + 52), 7, wheelPaint);
    canvas.drawCircle(Offset(cx + 22, cy + 52), 7, wheelPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
