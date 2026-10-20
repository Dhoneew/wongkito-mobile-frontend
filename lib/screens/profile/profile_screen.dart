
import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import '../notification/notification_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color orange = Color(0xFFFF6200);
  static const Color backgroundColor = Color(0xFFFAF9F9);
  static const Color textColor = Color(0xFF1A1C1C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFFFFE2C7),
            child: Icon(
              Icons.person,
              size: 45,
              color: orange,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Pelanggan Wong Kito',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kelola informasi akun Anda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: textColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildItem(context, Icons.edit_outlined, 'Edit Profil', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );
          }),
          _buildItem(context, Icons.location_on_outlined, 'Alamat'),
          _buildItem(context, Icons.receipt_long, 'Riwayat Pesanan'),
          _buildItem(context, Icons.notifications_none, 'Notifikasi', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          }),
          _buildItem(context, Icons.help_outline, 'Bantuan'),
          _buildItem(context, Icons.logout, 'Keluar'),
        ],
      ),
    );
  }

  static Widget _buildItem(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: ListTile(
        leading: Icon(icon, color: orange),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: textColor,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF888888),
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}
