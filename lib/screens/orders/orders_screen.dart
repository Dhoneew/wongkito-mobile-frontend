import 'package:flutter/material.dart';

import '../../data/order_store.dart';
import '../../features/orders/models/order.dart';
import '../../features/orders/viewmodels/order_viewmodel.dart';
import '../../main.dart';
import '../../theme/wkm_style.dart';
import 'order_detail_screen.dart';
import '../tracking/tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderViewModel viewModel = OrderStore.instance.viewModel;

  void _openTracking(String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrackingScreen(orderId: orderId),
      ),
    );
  }

  void _openDetail(String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailScreen(orderId: orderId),
      ),
    );
  }

  Widget _cardAction(IconData icon, String label, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: WkmColors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final visibleOrders = viewModel.visibleOrders;
        final isHistory = viewModel.selectedTab == 1;

        return Scaffold(
          backgroundColor: WkmColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 22,
                            color: WkmColors.orange,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Pesanan Saya',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: WkmColors.dark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 42,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: WkmColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            _buildTab(
                              'Dalam Proses (${viewModel.processingCount})',
                              0,
                            ),
                            _buildTab(
                              'Riwayat (${viewModel.historyCount})',
                              1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: visibleOrders.isEmpty
                      ? _buildEmptyState(isHistory)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                          itemCount: visibleOrders.length,
                          itemBuilder: (context, index) {
                            final order = visibleOrders[index];
                            return _buildOrderCard(order);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTab(String label, int index) {
    final selected = viewModel.selectedTab == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => viewModel.selectOrderTab(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected ? WkmColors.dark : WkmColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final isDone = order.status == 'Selesai';
    final statusColor = wkmStatusColor(order.status);
    final badgeBg = statusColor.withValues(alpha: 0.10);

    final typeInfo = order.orderType == 'Dine-in' && order.tableNumber.isNotEmpty
        ? '${order.orderType} · ${order.tableNumber}'
        : order.orderType;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: wkmCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                wkmFormatOrderDate(order.date),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: WkmColors.muted,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      wkmStatusIcon(order.status),
                      size: 13,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.status,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.id}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: WkmColors.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.items} · $typeInfo',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: WkmColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                viewModel.rupiah(order.price),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: WkmColors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: WkmColors.border),
          const SizedBox(height: 8),
          Row(
            children: [
              if (!isDone)
                const Icon(
                  Icons.schedule,
                  size: 14,
                  color: WkmColors.orange,
                ),
              if (!isDone) const SizedBox(width: 5),
              Expanded(
                child: Text(
                  isDone ? 'Pesanan telah selesai' : 'Estimasi ± 12 menit',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: WkmColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isDone)
                _cardAction(
                  Icons.track_changes,
                  'Lacak',
                  () => _openTracking(order.id),
                ),
              _cardAction(
                Icons.receipt_long,
                'Detail',
                () => _openDetail(order.id),
              ),
              if (isDone)
                _cardAction(
                  Icons.track_changes,
                  'Lacak',
                  () => _openTracking(order.id),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isHistory) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: WkmColors.softOrange,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isHistory ? Icons.history : Icons.receipt_long_outlined,
                size: 44,
                color: WkmColors.orange,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isHistory ? 'Belum ada riwayat pesanan' : 'Belum ada pesanan diproses',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WkmColors.dark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Yuk pesan kopi atau makanan favoritmu di Warkop Wong Kito.',
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
              child: wkmPrimaryButton(
                label: 'Jelajahi Menu',
                icon: Icons.restaurant,
                height: 44,
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
            ),
          ],
        ),
      ),
    );
  }
}
