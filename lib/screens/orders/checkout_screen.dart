import 'package:flutter/material.dart';

import '../../data/order_store.dart';
import '../../features/orders/models/cart_item.dart';
import '../../main.dart';
import '../../theme/wkm_style.dart';
import 'order_success_screen.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderStore store = OrderStore.instance;
  final TextEditingController noteController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    noteController.text = store.kitchenNote;
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? WkmColors.danger : WkmColors.dark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
  }

  Future<void> _confirmRemoveItem(CartItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Item?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: WkmColors.dark,
          ),
        ),
        content: Text(
          '${item.menuName} akan dihapus dari pesanan ini.',
          style: const TextStyle(fontFamily: 'Inter', fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Batal'),
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
    _showMessage('${item.menuName} dihapus dari pesanan.');
  }

  void _decrementQuantity(CartItem item) {
    if (item.quantity <= 1) {
      _confirmRemoveItem(item);
      return;
    }
    store.updateQuantity(item, item.quantity - 1);
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    if (store.cart.isEmpty) {
      _showMessage('Keranjang masih kosong. Tambahkan menu terlebih dahulu.', error: true);
      return;
    }

    if (store.orderType == 'Dine-in' && store.tableNumber.trim().isEmpty) {
      _showMessage('Pilih nomor meja terlebih dahulu.', error: true);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    // Beri umpan balik singkat agar tombol tidak terasa "mati" saat ditekan.
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    if (store.paymentMethod != 'QRIS') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Buat Pesanan?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: WkmColors.dark,
            ),
          ),
          content: Text(
            'Total ${wkmRupiah(store.cartTotal)} dengan metode '
            '${store.paymentMethod}. Pesanan akan diproses setelah dikonfirmasi.',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogCtx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: WkmColors.orange,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      );

      if (confirmed != true || !mounted) {
        if (mounted) setState(() => _isSubmitting = false);
        return;
      }
    }

    // checkout() mereset preferensi ke default, jadi metode pembayaran harus
    // ditangkap lebih awal untuk menentukan tujuan navigasi yang benar.
    final total = store.cartTotal;
    final paymentMethod = store.paymentMethod;
    final orderId = store.checkout();

    if (orderId == null) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showMessage('Gagal membuat pesanan. Silakan coba lagi.', error: true);
      }
      return;
    }

    if (!mounted) return;

    if (paymentMethod == 'QRIS') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentCodeScreen(
            orderId: orderId,
            totalAmount: total,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(orderId: orderId),
        ),
      );
    }

    if (mounted) setState(() => _isSubmitting = false);
  }

  Future<void> _chooseTable() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Pilih Nomor Meja',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: WkmColors.dark,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(10, (index) {
              final table = 'Meja ${(index + 1).toString().padLeft(2, '0')}';
              final isSelected = table == store.tableNumber;
              return ChoiceChip(
                label: Text(table),
                selected: isSelected,
                onSelected: (_) => Navigator.pop(dialogCtx, table),
                selectedColor: WkmColors.softOrange,
                backgroundColor: WkmColors.background,
                side: BorderSide(
                  color: isSelected ? WkmColors.orange : WkmColors.border,
                ),
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? WkmColors.dark : WkmColors.muted,
                ),
              );
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal'),
          ),
        ],
      ),
    );

    if (selected != null) store.setTableNumber(selected);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final isEmpty = store.cart.isEmpty;

        return Scaffold(
          backgroundColor: WkmColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: WkmColors.dark,
            elevation: 0.5,
            leading: wkmBackButton(() => Navigator.pop(context)),
            titleSpacing: 0,
            title: const Text(
              'Checkout',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: WkmColors.dark,
              ),
            ),
          ),
          body: isEmpty
              ? _buildEmptyCartView()
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        children: [
                          _buildSectionTitle('Jenis Pesanan'),
                          const SizedBox(height: 10),
                          _buildOrderType(),
                          if (store.orderType == 'Dine-in') ...[
                            const SizedBox(height: 12),
                            _buildTableCard(),
                          ],
                          const SizedBox(height: 22),
                          _buildSectionTitle(
                            'Daftar Menu (${store.cart.length} Item)',
                          ),
                          const SizedBox(height: 10),
                          ...store.cart.map(_buildCartItem),
                          const SizedBox(height: 18),
                          _buildSectionTitle('Catatan Pesanan'),
                          const SizedBox(height: 10),
                          _buildNote(),
                          const SizedBox(height: 22),
                          _buildSectionTitle('Metode Pembayaran'),
                          const SizedBox(height: 10),
                          _buildPayment(
                            'QRIS',
                            'Gopay, OVO, DANA, BCA, Livin & lainnya',
                          ),
                          _buildPayment(
                            'E-Wallet Langsung',
                            'Bayar langsung dengan saldo e-wallet',
                          ),
                          _buildPayment(
                            'Bayar Kasir (Cash / Tunai)',
                            'Bayar langsung di kasir saat pengambilan',
                          ),
                          const SizedBox(height: 12),
                          _buildSummary(),
                        ],
                      ),
                    ),
                    _buildPayButton(),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: WkmColors.dark,
      ),
    );
  }

  Widget _buildOrderType() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: WkmColors.border,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _typeButton('Dine-in', 'Dine-in'),
          _typeButton('Take Away', 'Take Away'),
        ],
      ),
    );
  }

  Widget _typeButton(String label, String value) {
    final selected = store.orderType == value;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: () => store.setOrderType(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected ? WkmColors.orange : WkmColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: wkmCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: WkmColors.softOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.table_restaurant,
              color: WkmColors.orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lokasi Duduk',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: WkmColors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  store.tableNumber,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: WkmColors.dark,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _chooseTable,
            child: const Text(
              'Ubah Meja',
              style: TextStyle(
                color: WkmColors.orange,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: wkmCardDecoration(),
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
                  width: 76,
                  height: 82,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 76,
                    height: 82,
                    color: WkmColors.softOrange,
                    child: const Icon(
                      Icons.local_cafe,
                      color: WkmColors.orange,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                        color: WkmColors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.temperature}, ${item.sugarLevel}'
                      '${item.extraShot ? ', Extra Shot (+Rp5.000)' : ''}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: WkmColors.muted,
                      ),
                    ),
                    if (item.note.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Catatan: ${item.note}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: WkmColors.muted,
                        ),
                      ),
                    ],
                    const SizedBox(height: 7),
                    Text(
                      wkmRupiah(item.subtotal),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: WkmColors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: WkmColors.border),
          const SizedBox(height: 6),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _confirmRemoveItem(item),
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Hapus'),
                style: TextButton.styleFrom(
                  foregroundColor: WkmColors.danger,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  textStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              _quantityButton(
                Icons.remove,
                () => _decrementQuantity(item),
              ),
              SizedBox(
                width: 38,
                child: Text(
                  '${item.quantity}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: WkmColors.dark,
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
      color: WkmColors.softOrange,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 17, color: WkmColors.orange),
        ),
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: wkmCardDecoration(),
      child: TextField(
        controller: noteController,
        onChanged: (value) => store.setKitchenNote(value),
        maxLines: 2,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: WkmColors.dark,
        ),
        decoration: InputDecoration(
          hintText: 'Contoh: es sedikit, gula dipisah, sambal terpisah...',
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: WkmColors.hint,
          ),
          filled: true,
          fillColor: WkmColors.background,
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPayment(String value, String description) {
    final selected = store.paymentMethod == value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => store.setPaymentMethod(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: selected ? WkmColors.softOrange : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? WkmColors.orange : WkmColors.border,
                width: selected ? 1.3 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: selected ? WkmColors.orange : WkmColors.disabled,
                  size: 21,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: WkmColors.dark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: WkmColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    color: WkmColors.orange,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: wkmCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: WkmColors.dark,
            ),
          ),
          const SizedBox(height: 14),
          _summaryRow('Subtotal', wkmRupiah(store.cartTotal)),
          _summaryRow('Biaya Layanan', wkmRupiah(0)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: WkmColors.border),
          ),
          _summaryRow(
            'Total Pembayaran',
            wkmRupiah(store.cartTotal),
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String price, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: bold ? 14 : 13,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                color: bold ? WkmColors.dark : WkmColors.muted,
              ),
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: bold ? 17 : 13,
              fontWeight: FontWeight.bold,
              color: bold ? WkmColors.orange : WkmColors.dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: WkmColors.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: wkmPrimaryButton(
          label: 'Buat Pesanan  ·  ${wkmRupiah(store.cartTotal)}',
          onPressed: _submit,
          loading: _isSubmitting,
          height: 52,
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
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: WkmColors.softOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: WkmColors.orange,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum ada yang di-checkout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WkmColors.dark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tambahkan menu favoritmu ke keranjang, lalu lanjutkan ke pembayaran.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: WkmColors.muted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            wkmPrimaryButton(
              label: 'Jelajahi Menu',
              icon: Icons.restaurant,
              height: 46,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainNavigation(initialIndex: 1),
                  ),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 10),
            wkmOutlineButton(
              label: 'Lihat Pesanan Saya',
              height: 46,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainNavigation(initialIndex: 2),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
