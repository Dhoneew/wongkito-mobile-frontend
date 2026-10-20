
import 'package:flutter/material.dart';
import '../../data/order_store.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const Color orange = Color(0xFFFF6200);
  static const Color bg = Color(0xFFFAF9F9);
  static const Color dark = Color(0xFF1A1C1C);

  final OrderStore store = OrderStore.instance;
  final TextEditingController noteController = TextEditingController();

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

  String rupiah(int value) {
    return 'Rp${value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: dark,
            elevation: 1,
            title: const Text(
              'Keranjang Checkout',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: store.cart.isEmpty
              ? const Center(
                  child: Text(
                    'Keranjang masih kosong.',
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildOrderType(),
                          const SizedBox(height: 14),
                          if (store.orderType == 'Dine-in')
                            _buildTableCard(),
                          const SizedBox(height: 22),
                          Text(
                            'Daftar Menu (${store.cart.length} Item)',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: dark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...store.cart.map(_buildCartItem),
                          const SizedBox(height: 14),
                          _buildNote(),
                          const SizedBox(height: 24),
                          const Text(
                            'Pilihan Pembayaran',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: dark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildPayment('QRIS', 'Gopay, OVO, Dana, BCA, Livin'),
                          _buildPayment('E-Wallet Langsung', 'Hubungkan akun Gopay / ShopeePay'),
                          _buildPayment('Bayar Kasir (Cash / Tunai)', 'Bayar langsung di kasir'),
                          const SizedBox(height: 14),
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

  Widget _buildOrderType() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA21A),
        borderRadius: BorderRadius.circular(6),
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
      child: GestureDetector(
        onTap: () {
          store.orderType = value;
          store.notifyListeners();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const Icon(Icons.table_restaurant, color: orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lokasi Duduk',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                Text(store.tableNumber,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          TextButton(
            onPressed: _chooseTable,
            child: const Text(
              'Ubah Meja',
              style: TextStyle(color: orange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseTable() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pilih Nomor Meja'),
        children: List.generate(10, (index) {
          final table = 'Meja ${(index + 1).toString().padLeft(2, '0')}';
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, table),
            child: Text(table),
          );
        }),
      ),
    );

    if (selected != null) {
      store.tableNumber = selected;
      store.notifyListeners();
    }
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              item.menuImage,
              width: 68,
              height: 76,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 68,
                height: 76,
                color: const Color(0xFFFFE0C2),
                child: const Icon(Icons.local_cafe, color: orange),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuName,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.temperature}, ${item.sugarLevel}'
                  '${item.extraShot ? ', Extra Shot (+Rp5.000)' : ''}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  rupiah(item.subtotal),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => store.removeItem(item),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: dark, fontSize: 12),
                      ),
                    ),
                    _quantityButton(
                      Icons.remove,
                      () => store.updateQuantity(item, item.quantity - 1),
                    ),
                    Container(
                      width: 34,
                      height: 32,
                      alignment: Alignment.center,
                      color: const Color(0xFFFFA21A),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: orange, width: 1.5),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Icon(icon, size: 17),
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catatan Pesanan Dapur:',
            style: TextStyle(fontFamily: 'Inter', fontSize: 13),
          ),
          TextField(
            controller: noteController,
            onChanged: (value) => store.kitchenNote = value,
            decoration: const InputDecoration(
              hintText: 'Contoh: es sedikit, gula dipisah...',
              border: InputBorder.none,
              isDense: true,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPayment(String value, String description) {
    final selected = store.paymentMethod == value;

    return GestureDetector(
      onTap: () {
        store.paymentMethod = value;
        store.notifyListeners();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? orange : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.circle_outlined,
              color: selected ? dark : const Color(0xFFCCCCCC),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
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

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RINGKASAN PEMBAYARAN',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 14),
          _summaryRow('Subtotal', rupiah(store.cartTotal)),
          _summaryRow('Biaya Layanan', rupiah(0)),
          const Divider(height: 24),
          _summaryRow(
            'Total Pembayaran',
            rupiah(store.cartTotal),
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
                fontSize: bold ? 15 : 13,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: bold ? 17 : 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      color: bg,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: store.cart.isEmpty ? null : _confirmOrder,
          child: Text(
            'BAYAR & BUAT PESANAN (${rupiah(store.cartTotal)})  →',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buat Pesanan?'),
        content: Text(
          'Total ${rupiah(store.cartTotal)} melalui ${store.paymentMethod}. '
          'Lanjutkan membuat pesanan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    store.checkout();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Pesanan Berhasil Dibuat!'),
        content: const Text(
          'Pesanan kamu sudah tercatat. Buka menu Pesanan untuk melihat statusnya.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );

    if (mounted) Navigator.pop(context);
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(7),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
