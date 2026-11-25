import 'package:flutter/material.dart';

import '../../features/address/viewmodels/address_viewmodel.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';
import '../../features/notification/viewmodels/notification_viewmodel.dart';
import '../../features/profile/repositories/profile_repository.dart';
import '../../features/profile/viewmodels/profile_viewmodel.dart';
import '../../theme/wkm_style.dart';
import '../address/address_screen.dart';
import '../help/help_screen.dart';
import '../login/login_page.dart';
import '../../main.dart';
import '../notification/notification_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  /// Diteruskan ke NotificationScreen supaya tap notifikasi mengganti tab
  /// dalam MainNavigation yang sama, bukan membuat navigasi baru.
  final ValueChanged<int>? onNavigateTab;

  const ProfileScreen({super.key, this.onNavigateTab});

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
    viewModel.addListener(_onProfileChanged);
    viewModel.loadProfile();
    authViewModel = AuthViewModel(AuthRepository());
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    viewModel.removeListener(_onProfileChanged);
    viewModel.dispose();
    authViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WkmColors.background,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: WkmColors.background,
        foregroundColor: WkmColors.dark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 42,
            backgroundColor: WkmColors.softOrange,
            child: Icon(Icons.person, size: 45, color: WkmColors.orange),
          ),
          const SizedBox(height: 12),
          Text(
            viewModel.profile?.name ?? 'Memuat profil...',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: WkmColors.dark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            viewModel.profile?.description ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: WkmColors.muted,
            ),
          ),
          const SizedBox(height: 8),
          if ((viewModel.profile?.email ?? '').isNotEmpty)
            Text(
              viewModel.profile!.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: WkmColors.muted,
              ),
            ),
          const SizedBox(height: 24),

          ...viewModel.menus.map((menu) {
            return _buildItem(
              icon: _getMenuIcon(menu.action),
              title: menu.title,
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
          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
        );

        if (mounted) {
          viewModel.loadProfile();
        }
        break;

      case 'notification':
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationScreen(
              onNavigateTab: widget.onNavigateTab,
            ),
          ),
        );
        break;

      case 'logout':
        _showLogoutDialog(context);
        break;

      case 'address':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddressScreen()),
        );
        break;

      case 'order_history':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const MainNavigation(initialIndex: 2),
          ),
          (route) => false,
        );
        break;

      case 'help':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HelpScreen()),
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menu ini belum tersedia pada versi demo.'),
          ),
        );
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
              child: const Text(
                'Batal',
                style: TextStyle(color: WkmColors.muted),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: WkmColors.orange,
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
      // Bersihkan data demo supaya akun berikutnya tidak mewarisi profil,
      // alamat, atau status baca notifikasi dari akun sebelumnya.
      ProfileRepository.instance.reset();
      AddressViewModel.shared.reset();
      NotificationViewModel.shared.reset();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  static Widget _buildItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: wkmCardDecoration(radius: 8),
      // Material transparan menjaga ripple ListTile tetap terlihat di atas
      // dekorasi kartu.
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: WkmColors.orange),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: WkmColors.dark,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: WkmColors.muted),
          onTap: onTap,
          minLeadingWidth: 32,
        ),
      ),
    );
  }
}
