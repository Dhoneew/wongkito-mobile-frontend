import '../models/profile.dart';
import '../models/profile_menu_item.dart';

class ProfileRepository {
  ProfileRepository._internal();

  static final ProfileRepository instance = ProfileRepository._internal();

  static const _defaultProfile = Profile(
    name: 'Pelanggan Wong Kito',
    description: 'Kelola informasi akun Anda',
    username: '',
    email: '',
  );

  Profile _profile = _defaultProfile;

  Profile getProfile() {
    return _profile;
  }

  List<ProfileMenuItem> getProfileMenus() {
    return const [
      ProfileMenuItem(title: 'Edit Profil', action: 'edit_profile'),
      ProfileMenuItem(title: 'Alamat', action: 'address'),
      ProfileMenuItem(title: 'Riwayat Pesanan', action: 'order_history'),
      ProfileMenuItem(title: 'Notifikasi', action: 'notification'),
      ProfileMenuItem(title: 'Bantuan', action: 'help'),
      ProfileMenuItem(title: 'Keluar', action: 'logout'),
    ];
  }

  void updateProfile(Profile profile) {
    _profile = profile;
  }

  /// Dipakai saat logout demo agar akun berikutnya tidak mewarisi profil lama.
  void reset() {
    _profile = _defaultProfile;
  }
}
