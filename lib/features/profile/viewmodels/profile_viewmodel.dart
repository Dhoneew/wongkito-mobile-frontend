import 'package:flutter/foundation.dart';

import '../models/profile.dart';
import '../models/profile_menu_item.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  static final RegExp emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final ProfileRepository repository;

  ProfileViewModel(this.repository);

  Profile? _profile;

  Profile? get profile => _profile;

  List<ProfileMenuItem> get menus {
    return repository.getProfileMenus();
  }

  void loadProfile() {
    _profile = repository.getProfile();
    notifyListeners();
  }

  /// Mengembalikan `null` jika berhasil, atau pesan error yang siap ditampilkan.
  String? updateProfile({
    required String name,
    required String username,
    required String email,
    String password = '',
    String confirmPassword = '',
  }) {
    if (_profile == null) {
      return 'Profil belum siap. Silakan coba lagi.';
    }

    final trimmedName = name.trim();
    final trimmedUsername = username.trim();
    final trimmedEmail = email.trim();

    if (trimmedName.isEmpty) {
      return 'Nama wajib diisi.';
    }
    if (trimmedUsername.isEmpty) {
      return 'Username wajib diisi.';
    }
    if (trimmedEmail.isEmpty) {
      return 'Email wajib diisi.';
    }
    if (!emailPattern.hasMatch(trimmedEmail)) {
      return 'Format email tidak valid.';
    }
    if (password.isNotEmpty && password.length < 6) {
      return 'Password minimal 6 karakter.';
    }
    if (password.isEmpty && confirmPassword.isNotEmpty) {
      return 'Isi password terlebih dahulu sebelum konfirmasi.';
    }
    if (password != confirmPassword) {
      return 'Konfirmasi password tidak cocok.';
    }

    final Profile updatedProfile = _profile!.copyWith(
      name: trimmedName,
      username: trimmedUsername,
      email: trimmedEmail,
    );

    repository.updateProfile(updatedProfile);

    _profile = updatedProfile;
    notifyListeners();

    return null;
  }
}
