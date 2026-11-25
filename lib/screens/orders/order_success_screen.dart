import 'package:flutter/material.dart';

import '../../data/order_store.dart';
import '../../main.dart';
import '../../theme/wkm_style.dart';
import '../tracking/tracking_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
  });

  static const Color primaryOrange = WkmColors.orange;
  static const Color bg = WkmColors.background;
  static const Color dark = WkmColors.dark;
  static const Color muted = WkmColors.muted;
  static const Color borderColor = WkmColors.border;

  void _goToOrders(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigation(initialIndex: 2),
      ),
      (route) => false,
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: dark,
        elevation: 0.5,
        title: const Text(
          'Pesanan Berhasil Dibuat!',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: primaryOrange,
              ),
              const SizedBox(height: 12),
              const Text(
                'Detail pesanan belum tersedia',
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
                'Coba lihat daftar pesanan kamu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: muted,
                ),
              ),
              const SizedBox(height: 20),
              wkmPrimaryButton(
                label: 'Lihat Daftar Pesanan',
                height: 46,
                onPressed: () => _goToOrders(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = OrderStore.instance.viewModel.getOrderById(orderId);
    if (order == null) return _buildNotFound(context);

    final total = order.price;
    final paymentMethod = order.paymentMethod;
    final orderType = order.orderType;
    final tableNumber = order.tableNumber;
    final note = order.note;
    final details = order.details;
    final paymentLabel = paymentMethod.startsWith('QRIS')
        ? 'QRIS (Simulasi)'
        : paymentMethod;
    final paymentStatus = order.paymentStatus;
    final isQris = paymentMethod.startsWith('QRIS');
    // Cash memang "Lunas" di data lokal, tetapi dibayar di kasir — jangan
    // diklaim sebagai pembayaran yang baru saja berhasil di aplikasi.
    final isQrisPaid = isQris && paymentStatus == 'Lunas';
    final headline =
        isQrisPaid ? 'Pembayaran Berhasil' : 'Pesanan Berhasil Dibuat!';
    final subtitle = isQrisPaid
        ? 'Pembayaran simulasi sudah dikonfirmasi. Pesananmu siap disiapkan.'
        : isQris
            ? 'Pesananmu dibuat dan menunggu konfirmasi pembayaran QRIS.'
            : 'Pesananmu sudah kami terima. Bayar di kasir saat mengambil pesanan.';

    return PopScope(
      // Back sistem dari halaman sukses mengarah ke Riwayat, bukan ke
      // checkout lama yang keranjangnya sudah kosong.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goToOrders(context);
      },
      child: Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                children: [
                  Center(
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: WkmColors.successSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: const BoxDecoration(
                            color: WkmColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    headline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: muted,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nomor Pesanan: #$orderId',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Pesanan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: dark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _infoRow('Nomor Pesanan', '#$orderId'),
                        _infoRow('Jenis Pesanan', orderType),
                        if (orderType == 'Dine-in' && tableNumber.isNotEmpty)
                          _infoRow('Nomor Meja', tableNumber),
                        _infoRow('Metode Pembayaran', paymentLabel),
                        _infoRow('Status Pembayaran', paymentStatus),
                        _infoRow('Status', order.status),
                        if (note.isNotEmpty) _infoRow('Catatan', note),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: borderColor),
                        ),
                        const Text(
                          'Ringkasan Item',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: dark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...details.map((item) {
                          final qty = item['quantity'] ?? 1;
                          final name = item['menuName'] ?? '';
                          final sub = (item['subtotal'] as int?) ?? 0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${qty}x $name',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      color: dark,
                                    ),
                                  ),
                                ),
                                Text(
                                  wkmRupiah(sub),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: dark,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: borderColor),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pembayaran',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: dark,
                              ),
                            ),
                            Text(
                              wkmRupiah(total),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryOrange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrackingScreen(
                              orderId: orderId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Lihat Status Pesanan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  wkmOutlineButton(
                    label: 'Lihat Riwayat Pesanan',
                    height: 46,
                    onPressed: () => _goToOrders(context),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Kembali ke Home',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryOrange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: muted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
