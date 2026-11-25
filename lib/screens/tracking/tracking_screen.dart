import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/order_store.dart';
import '../../features/orders/viewmodels/tracking_viewmodel.dart';
import '../../main.dart';
import '../../theme/wkm_style.dart';

class TrackingScreen extends StatefulWidget {
  final String orderId;

  const TrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final OrderStore store = OrderStore.instance;
  late final TrackingViewModel viewModel;
  Timer? _simulationTimer;

  @override
  void initState() {
    super.initState();
    viewModel = TrackingViewModel(
      repository: store.viewModel.repository,
      orderId: widget.orderId,
    );
    _startSimulation();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _advanceSilently();
    });
  }

  void _advanceSilently() {
    if (!mounted || !viewModel.canAdvance) {
      _simulationTimer?.cancel();
      return;
    }
    viewModel.advanceStatus();
    // Beritahu seluruh aplikasi (termasuk halaman riwayat pesanan).
    store.refresh();
    if (!viewModel.canAdvance) _simulationTimer?.cancel();
  }

  void _advanceManually() {
    // Hindari lompat dua status bila tombol ditekan bersamaan dengan timer.
    _simulationTimer?.cancel();
    _advanceSilently();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    viewModel.dispose();
    super.dispose();
  }

  String _clock(DateTime value) {
    return '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}';
  }

  ({String entered, String estimate}) get _timeInfo {
    final placedAt = DateTime.tryParse(viewModel.order?.date ?? '');
    if (placedAt == null) {
      return (entered: 'Baru saja', estimate: '± 12 menit');
    }
    final estimate = placedAt.add(const Duration(minutes: 12));
    return (entered: _clock(placedAt), estimate: '${_clock(estimate)} WIB');
  }

  double get _progress {
    switch (viewModel.status) {
      case TrackingViewModel.statusProcessing:
        return 0.35;
      case TrackingViewModel.statusReady:
        return 0.75;
      case TrackingViewModel.statusCompleted:
        return 1;
      default:
        return 0;
    }
  }

  void _goToOrders() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation(initialIndex: 2)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final found = viewModel.isOrderFound;
        final times = _timeInfo;

        return Scaffold(
          backgroundColor: WkmColors.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: _goToOrders,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 19,
                        color: WkmColors.dark,
                      ),
                      tooltip: 'Kembali ke pesanan',
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lacak Pesanan #${widget.orderId}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: WkmColors.dark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (!found) ...[
                  _buildCard(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 48,
                          color: WkmColors.muted,
                        ),
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
                          'Coba periksa daftar pesanan kamu.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: WkmColors.muted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        wkmPrimaryButton(
                          label: 'Lihat Daftar Pesanan',
                          height: 46,
                          onPressed: _goToOrders,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.smart_toy, color: WkmColors.orange, size: 23),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Estimasi Waktu',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: WkmColors.dark,
                                ),
                              ),
                            ),
                            Icon(Icons.auto_awesome,
                                color: WkmColors.orange, size: 17),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          viewModel.isCompleted
                              ? 'Pesanan selesai. Selamat menikmati!'
                              : 'Perkiraan selesai dalam 8–12 menit. Estimasi '
                                  'diperbarui mengikuti progres pesanan kamu.',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            height: 1.5,
                            color: WkmColors.muted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: _progress,
                            minHeight: 7,
                            color: WkmColors.orange,
                            backgroundColor: WkmColors.border,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Masuk: ${times.entered}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: WkmColors.muted,
                              ),
                            ),
                            Text(
                              'Estimasi: ${times.estimate}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: WkmColors.dark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Progres Pesanan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: WkmColors.dark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildStep(
                          icon: Icons.check,
                          title: 'Pesanan Diterima',
                          description: 'Pesanan berhasil diterima oleh sistem',
                          time: 'Selesai',
                          done: true,
                        ),
                        _buildStep(
                          icon: Icons.local_cafe,
                          title: 'Diproses Barista',
                          description: 'Pesanan sedang disiapkan oleh barista',
                          time: viewModel.isProcessing
                              ? 'Sedang Diproses'
                              : viewModel.currentStepIndex >= 1
                                  ? 'Selesai'
                                  : 'Menunggu',
                          done: viewModel.currentStepIndex >= 1,
                          active: viewModel.isProcessing,
                        ),
                        _buildStep(
                          icon: Icons.shopping_bag,
                          title: 'Siap Diantar',
                          description: 'Pesanan siap diserahkan kepada pelanggan',
                          time: viewModel.isReady
                              ? 'Siap Diantar'
                              : viewModel.currentStepIndex >= 2
                                  ? 'Selesai'
                                  : 'Menunggu',
                          done: viewModel.currentStepIndex >= 2,
                          active: viewModel.isReady,
                        ),
                        _buildStep(
                          icon: Icons.check_circle,
                          title: 'Pesanan Selesai',
                          description: 'Pesanan telah selesai',
                          time: viewModel.isCompleted ? 'Selesai' : 'Menunggu',
                          done: viewModel.isCompleted,
                          active: viewModel.isCompleted,
                          last: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detail Pesanan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: WkmColors.dark,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow('Status', viewModel.status),
                        _buildInfoRow('Jumlah Item', viewModel.items),
                        _buildInfoRow('Jenis Pesanan', viewModel.orderType),
                        if (viewModel.orderType == 'Dine-in' &&
                            viewModel.tableNumber.isNotEmpty)
                          _buildInfoRow('Nomor Meja', viewModel.tableNumber),
                        if (viewModel.paymentMethod.isNotEmpty)
                          _buildInfoRow('Pembayaran', viewModel.paymentMethod),
                        if (viewModel.paymentStatus.isNotEmpty)
                          _buildInfoRow(
                            'Status Pembayaran',
                            viewModel.paymentStatus,
                          ),
                        if (viewModel.note.isNotEmpty)
                          _buildInfoRow('Catatan', viewModel.note),
                        if (viewModel.details.isNotEmpty) ...[
                          const Divider(height: 20, color: WkmColors.border),
                          const Text(
                            'Item Pesanan',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: WkmColors.dark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...viewModel.details.map(_buildDetailItem),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: WkmColors.softOrange,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: WkmColors.warningBorder),
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
                          wkmRupiah(viewModel.total),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: WkmColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (viewModel.canAdvance)
                    wkmOutlineButton(
                      label: 'Simulasikan Status Berikutnya',
                      height: 46,
                      onPressed: _advanceManually,
                    ),
                  if (viewModel.canAdvance) const SizedBox(height: 10),
                  wkmPrimaryButton(
                    label: 'Kembali ke Daftar Pesanan',
                    height: 48,
                    onPressed: _goToOrders,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
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

  Widget _buildDetailItem(Map<String, dynamic> item) {
    final qty = (item['quantity'] as num?)?.toInt() ?? 1;
    final name = (item['menuName'] ?? '').toString();
    final options = <String>[
      (item['temperature'] ?? '').toString(),
      (item['sugarLevel'] ?? '').toString(),
      if (item['extraShot'] == true) 'Extra Shot',
    ].where((value) => value.isNotEmpty).join(', ');
    final subtotal = (item['subtotal'] as num?)?.toInt() ?? 0;
    final note = (item['note'] ?? '').toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${qty}x $name',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: WkmColors.dark,
                  ),
                ),
              ),
              Text(
                wkmRupiah(subtotal),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: WkmColors.dark,
                ),
              ),
            ],
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
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: wkmCardDecoration(),
      child: child,
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    bool done = false,
    bool active = false,
    bool last = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: done
                      ? WkmColors.orange
                      : active
                          ? WkmColors.softOrange
                          : WkmColors.border,
                  child: Icon(
                    icon,
                    size: 13,
                    color: done
                        ? Colors.white
                        : active
                            ? WkmColors.orange
                            : WkmColors.disabled,
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: done
                          ? WkmColors.progress
                          : WkmColors.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: done || active ? WkmColors.dark : WkmColors.muted,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      height: 1.45,
                      color: WkmColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              time,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                height: 1.4,
                color: active ? WkmColors.orange : WkmColors.muted,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
