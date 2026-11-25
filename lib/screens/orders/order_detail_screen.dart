import 'package:flutter/material.dart';

import '../../data/order_store.dart';
import '../../features/orders/models/order.dart';
import '../../theme/wkm_style.dart';
import '../tracking/tracking_screen.dart';

/// Detail pesanan yang dipakai dari tab Riwayat.
/// Menampilkan seluruh informasi yang tersimpan di model [Order] tanpa
/// mengubah data atau menambah backend baru.
class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final store = OrderStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final currentOrder = store.viewModel.getOrderById(orderId);

        return Scaffold(
          backgroundColor: WkmColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: WkmColors.dark,
            elevation: 0.5,
            leading: wkmBackButton(() => Navigator.pop(context)),
            titleSpacing: 0,
            title: wkmAppBarTitle(
              'Detail Pesanan',
              subtitle: '#$orderId',
            ),
          ),
          body: currentOrder == null
              ? _buildNotFound(context)
              : SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    children: [
                      _buildInfoCard(currentOrder),
                      const SizedBox(height: 14),
                      _buildItemsCard(currentOrder),
                      const SizedBox(height: 14),
                      _buildTotalCard(currentOrder),
                      const SizedBox(height: 18),
                      if (currentOrder.status != 'Selesai') ...[
                        wkmOutlineButton(
                          label: 'Lacak Pesanan',
                          height: 46,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  TrackingScreen(orderId: orderId),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      wkmPrimaryButton(
                        label: 'Kembali ke Daftar Pesanan',
                        height: 48,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: WkmColors.muted),
            const SizedBox(height: 12),
            const Text(
              'Pesanan tidak ditemukan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WkmColors.dark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba periksa kembali daftar pesanan kamu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: WkmColors.muted,
              ),
            ),
            const SizedBox(height: 20),
            wkmPrimaryButton(
              label: 'Kembali',
              height: 46,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Order order) {
    final typeInfo = order.orderType == 'Dine-in' && order.tableNumber.isNotEmpty
        ? '${order.orderType} · ${order.tableNumber}'
        : order.orderType;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: wkmCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${order.id}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: WkmColors.dark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: wkmStatusColor(order.status).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      wkmStatusIcon(order.status),
                      size: 13,
                      color: wkmStatusColor(order.status),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.status,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: wkmStatusColor(order.status),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _row('Tanggal', wkmFormatOrderDate(order.date)),
          _row('Jumlah Item', order.items),
          _row('Jenis Pesanan', typeInfo),
          if (order.orderType == 'Dine-in')
            _row('Nomor Meja', order.tableNumber.isEmpty ? '-' : order.tableNumber),
          _row('Metode Pembayaran', order.paymentMethod),
          if (order.paymentStatus.isNotEmpty)
            _row('Status Pembayaran', order.paymentStatus),
          if (order.note.isNotEmpty) _row('Catatan', order.note),
        ],
      ),
    );
  }

  Widget _buildItemsCard(Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: wkmCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Pesanan',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: WkmColors.dark,
            ),
          ),
          const SizedBox(height: 12),
          if (order.details.isEmpty)
            const Text(
              'Detail item tidak tersedia.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: WkmColors.muted,
              ),
            )
          else
            ...order.details.map(_buildItem),
        ],
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> item) {
    final qty = (item['quantity'] as num?)?.toInt() ?? 1;
    final name = (item['menuName'] ?? '').toString();
    final price = (item['price'] as num?)?.toInt() ?? 0;
    final subtotal = (item['subtotal'] as num?)?.toInt() ?? price * qty;
    final options = <String>[
      (item['temperature'] ?? '').toString(),
      (item['sugarLevel'] ?? '').toString(),
      if (item['extraShot'] == true) 'Extra Shot',
    ].where((value) => value.isNotEmpty).join(', ');
    final note = (item['note'] ?? '').toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${qty}x $name',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: WkmColors.dark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${wkmRupiah(price)} / item',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: WkmColors.muted,
                  ),
                ),
                if (options.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    options,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: WkmColors.muted,
                    ),
                  ),
                ],
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Catatan: $note',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: WkmColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            wkmRupiah(subtotal),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: WkmColors.dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(Order order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: WkmColors.softOrange,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WkmColors.orange.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Pesanan',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: WkmColors.dark,
            ),
          ),
          Text(
            wkmRupiah(order.price),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: WkmColors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: WkmColors.muted,
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
                color: WkmColors.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
