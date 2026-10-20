
import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  final String orderId;
  final int total;

  const TrackingScreen({
    super.key,
    this.orderId = 'WK-001',
    this.total = 61000,
  });

  static const Color orange = Color(0xFFFF6200);
  static const Color dark = Color(0xFF1A1C1C);
  static const Color background = Color(0xFFFAF9F9);

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
          padding: const EdgeInsets.all(14),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: dark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lacak Pesanan #$orderId',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

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
                            fontSize: 13,
                            color: dark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Perkiraan selesai dalam 8–12 menit. '
                    'Estimasi ditampilkan berdasarkan antrean pesanan, '
                    'kapasitas barista, dan tingkat kesulitan menu.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      height: 1.5,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0.65,
                      minHeight: 6,
                      color: orange,
                      backgroundColor: Color(0xFFE6E6E6),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Masuk: 14:10',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        'Estimasi: 14:22 WIB',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progres Pesanan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 15),

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
                    description: 'Selamat menikmati pesanan Anda',
                    time: 'Menunggu',
                    last: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'Total pesanan: ${rupiah(total)}',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: dark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
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
    final Color color =
        done || active ? orange : const Color(0xFFBDBDBD);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: color,
                  child: Icon(
                    icon,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFFE0E0E0),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9,
                      height: 1.4,
                      color: dark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 4),

          Flexible(
            child: Text(
              time,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 8,
                color: active ? orange : const Color(0xFF666666),
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
