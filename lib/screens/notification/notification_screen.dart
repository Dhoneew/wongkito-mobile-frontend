import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const Color orange = Color(0xFFFF6200);
  static const Color backgroundColor = Color(0xFFFAF9F9);
  static const Color textColor = Color(0xFF1A1C1C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildNotificationItem(
            icon: Icons.takeout_dining,
            iconBgColor: const Color(0xFFFFE8C5),
            iconColor: orange,
            title: 'Pesanan siap diambil',
            subtitle: 'Pesanan sudah selesai dibuat',
          ),
          _buildNotificationItem(
            icon: Icons.takeout_dining,
            iconBgColor: const Color(0xFFFFE8C5),
            iconColor: orange,
            title: 'Pesanan sedang dibuat',
            subtitle: 'Barista sedang menyiapkan pesanan',
          ),
          _buildNotificationItem(
            icon: Icons.local_offer,
            iconBgColor: const Color(0xFFFFD6D6),
            iconColor: orange,
            title: 'Promo paket kenyang hemat',
            subtitle: 'Dapatkan diskon spesial hari ini',
            isPromo: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool isPromo = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isPromo ? const Color(0xFFFFE8E8) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPromo ? const Color(0xFFFFCCCC) : const Color(0xFFEAEAEA),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

