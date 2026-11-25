import 'package:flutter/foundation.dart';

import '../../profile/models/profile.dart';
import '../../profile/repositories/profile_repository.dart';
import '../models/auth_user.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  static final RegExp emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final AuthRepository repository;

  AuthViewModel(this.repository);

  AuthUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  AuthUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  bool get hasUser => _currentUser != null;

  /// Pesan validasi yang dipakai bersama oleh form login, register, dan lupa password.
  String? validateEmail(String value) {
    final email = value.trim();
    if (email.isEmpty) return 'Email wajib diisi';
    if (!emailPattern.hasMatch(email)) return 'Format email tidak valid';
    return null;
  }

  String? validateUsername(String value) {
    if (value.trim().isEmpty) return 'Username wajib diisi';
    return null;
  }

  String? validatePassword(String value, {int minLength = 6}) {
    if (value.isEmpty) return 'Kata sandi wajib diisi';
    if (value.length < minLength) return 'Minimal $minLength karakter';
    return null;
  }

  bool isPasswordStrong(String password) {
    final hasMin8Chars = password.length >= 8;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    return hasMin8Chars && hasLetter && hasNumber;
  }

  bool passwordsMatch(String password, String confirmation) {
    return password.isNotEmpty &&
        confirmation.isNotEmpty &&
        password == confirmation;
  }

  // LOGIN

  Future<bool> login({required String email, required String password}) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      _errorMessage = emailError;
      notifyListeners();
      return false;
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      _errorMessage = passwordError;
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      _currentUser = await repository.login(
        email: email.trim(),
        password: password,
      );

      _syncProfile(_currentUser!);
      _setLoading(false);
      _successMessage = 'Login simulasi berhasil!';
      notifyListeners();

      return true;
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Login gagal. Silakan coba kembali.';
      notifyListeners();

      return false;
    }
  }

  // REGISTER

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final usernameError = validateUsername(username);
    if (usernameError != null) {
      _errorMessage = usernameError;
      notifyListeners();
      return false;
    }

    final emailError = validateEmail(email);
    if (emailError != null) {
      _errorMessage = emailError;
      notifyListeners();
      return false;
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      _errorMessage = passwordError;
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      _currentUser = await repository.register(
        username: username.trim(),
        email: email.trim(),
        password: password,
      );

      _syncProfile(_currentUser!, name: username.trim());
      _setLoading(false);
      _successMessage = 'Akun berhasil dibuat!';
      notifyListeners();

      return true;
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Registrasi gagal. Silakan coba kembali.';
      notifyListeners();

      return false;
    }
  }

  // FORGOT PASSWORD

  Future<bool> sendResetLink(String email) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      _errorMessage = emailError;
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final result = await repository.sendResetLink(email.trim());

      _setLoading(false);

      if (result) {
        _successMessage = 'Link reset berhasil disiapkan (simulasi).';
      } else {
        _errorMessage = 'Gagal menyiapkan link reset.';
      }

      notifyListeners();
      return result;
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Terjadi kesalahan. Silakan coba kembali.';
      notifyListeners();

      return false;
    }
  }

  // RESET PASSWORD

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      _errorMessage = emailError;
      notifyListeners();
      return false;
    }

    if (!isPasswordStrong(newPassword)) {
      _errorMessage =
          'Password minimal 8 karakter dan mengandung huruf serta angka.';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final result = await repository.resetPassword(
        email: email.trim(),
        newPassword: newPassword,
      );

      _setLoading(false);

      if (result) {
        _successMessage = 'Password berhasil diubah (simulasi).';
      } else {
        _errorMessage = 'Gagal mengubah password.';
      }

      notifyListeners();
      return result;
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Terjadi kesalahan. Silakan coba kembali.';
      notifyListeners();

      return false;
    }
  }

  // LOGOUT

  void logout() {
    repository.logout();
    _currentUser = null;
    notifyListeners();
  }

  // STATE MANAGEMENT

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Menyambungkan akun yang berhasil login ke data profil yang ditampilkan.
  /// Tanpa penyimpanan baru: cukup memakai singleton ProfileRepository.
  void _syncProfile(AuthUser user, {String? name}) {
    final localPart = user.email.split('@').first;
    final derivedName = localPart.isEmpty
        ? 'Pelanggan Wong Kito'
        : localPart[0].toUpperCase() + localPart.substring(1);

    ProfileRepository.instance.updateProfile(
      Profile(
        name: name ?? derivedName,
        description: 'Kelola informasi akun Anda',
        username: user.username,
        email: user.email,
      ),
    );
  }
}
