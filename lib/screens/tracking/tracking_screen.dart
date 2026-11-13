
import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  final String orderId;
  final int total;

  const TrackingScreen({
    super.key,
    this.orderId = 'WK-001',
    this.total = 61000,
  });

  // COLOR PALETTE WONG KITO
  static const Color orange = Color(0xFFF57C00);
  static const Color softOrange = Color(0xFFFFF3E0);
  static const Color dark = Color(0xFF292929);
  static const Color muted = Color(0xFF757575);
  static const Color background = Color(0xFFFAFAFA);
  static const Color borderColor = Color(0xFFEEEEEE);
  static const Color inactive = Color(0xFFBDBDBD);

  String rupiah(int value) {
    return 'Rp${value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // HEADER
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 19,
                    color: dark,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 40,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lacak Pesanan #$orderId',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // AI ESTIMASI WAKTU
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.smart_toy,
                        color: orange,
                        size: 23,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'AI Estimasi Waktu',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: dark,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.auto_awesome,
                        color: orange,
                        size: 17,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Perkiraan selesai dalam 8–12 menit. '
                    'Estimasi ditampilkan berdasarkan antrean pesanan, '
                    'kapasitas barista, dan tingkat kesulitan menu.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      height: 1.5,
                      color: muted,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      value: 0.65,
                      minHeight: 7,
                      color: orange,
                      backgroundColor: Color(0xFFEEEEEE),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Masuk: 14:10',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          color: muted,
                        ),
                      ),
                      Text(
                        'Estimasi: 14:22 WIB',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: dark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // PROGRES PESANAN
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
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildStep(
                    icon: Icons.check,
                    title: 'Pesanan Diterima Barista',
                    description:
                        'Kasir mengonfirmasi pembayaran QRIS',
                    time: '14:10 WIB',
                    done: true,
                  ),

                  _buildStep(
                    icon: Icons.local_cafe,
                    title: 'Diproses Barista',
                    description:
                        'Pesanan sedang disiapkan oleh barista',
                    time: 'Sedang Diproses',
                    active: true,
                  ),

                  _buildStep(
                    icon: Icons.shopping_bag,
                    title: 'Siap Diantar ke Meja 05',
                    description:
                        'Pesanan akan diantarkan langsung ke meja',
                    time: 'Menunggu',
                  ),

                  _buildStep(
                    icon: Icons.check_circle,
                    title: 'Selesai Dinikmati',
                    description:
                        'Selamat menikmati pesanan Anda',
                    time: 'Menunggu',
                    last: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // TOTAL PESANAN
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: softOrange,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFE0B2),
                ),
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
                      color: dark,
                    ),
                  ),
                  Text(
                    rupiah(total),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: orange,
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

  // CARD STYLE
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // TIMELINE ITEM
  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    bool done = false,
    bool active = false,
    bool last = false,
  }) {
    final Color statusColor =
        done || active ? orange : inactive;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON DAN GARIS TIMELINE
          SizedBox(
            width: 28,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: done
                      ? orange
                      : active
                          ? softOrange
                          : const Color(0xFFF0F0F0),
                  child: Icon(
                    icon,
                    size: 13,
                    color: done
                        ? Colors.white
                        : active
                            ? orange
                            : inactive,
                  ),
                ),

                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: done
                          ? const Color(0xFFFFCC80)
                          : const Color(0xFFEEEEEE),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // INFORMASI STATUS
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
                      color: done || active ? dark : muted,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      height: 1.45,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 6),

          // WAKTU STATUS
          Flexible(
            child: Text(
              time,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                height: 1.4,
                color: active ? orange : muted,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
