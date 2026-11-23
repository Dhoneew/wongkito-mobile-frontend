import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';
import '../help/help_screen.dart';
import '../address/address_screen.dart';
import '../../features/profile/repositories/profile_repository.dart';
import '../../features/profile/viewmodels/profile_viewmodel.dart';

import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';
import '../notification/notification_screen.dart';
import '../login/login_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthViewModel authViewModel;

  late final ProfileViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ProfileViewModel(ProfileRepository.instance);
    viewModel.loadProfile();
    authViewModel = AuthViewModel(AuthRepository());
  }

  @override
  void dispose() {
    viewModel.dispose();
    authViewModel.dispose();
    super.dispose();
  }

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
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
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
            child: Icon(Icons.person, size: 45, color: orange),
          ),
          const SizedBox(height: 12),
          Text(
            viewModel.profile?.name ?? 'Memuat profil...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            viewModel.profile?.description ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: textColor,
            ),
          ),
          const SizedBox(height: 24),

          ...viewModel.menus.map((menu) {
            return _buildItem(
              context,
              _getMenuIcon(menu.action),
              menu.title,
              onTap: () => _handleMenuAction(context, menu.action),
            );
          }),
        ],
      ),
    );
  }

  static IconData _getMenuIcon(String action) {
    switch (action) {
      case 'edit_profile':
        return Icons.edit_outlined;
      case 'address':
        return Icons.location_on_outlined;
      case 'order_history':
        return Icons.receipt_long;
      case 'notification':
        return Icons.notifications_none;
      case 'help':
        return Icons.help_outline;
      case 'logout':
        return Icons.logout;
      default:
        return Icons.help_outline;
    }
  }

  Future<void> _handleMenuAction(BuildContext context, String action) async {
    switch (action) {
      case 'edit_profile':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
        );

        if (mounted) {
          setState(() {
            viewModel.loadProfile();
          });
        }
        break;

      case 'notification':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        );
        break;

      case 'logout':
        _showLogoutDialog(context);
        break;

      case 'address':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddressScreen()),
        );
        break;

      case 'order_history':
        break;

      case 'help':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HelpScreen()),
        );
        break;
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi Keluar',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun Wong Kito?',
            style: TextStyle(fontFamily: 'Inter'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      authViewModel.logout();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  static Widget _buildItem(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
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
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF888888)),
        onTap: onTap ?? () {},
      ),
    );
  }
}
