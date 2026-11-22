import 'package:flutter/foundation.dart';

import '../models/auth_user.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
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
    _setLoading(true);

    try {
      _currentUser = await repository.login(
        email: email.trim(),
        password: password,
      );

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
    _setLoading(true);

    try {
      _currentUser = await repository.register(
        username: username.trim(),
        email: email.trim(),
        password: password,
      );

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
    _setLoading(true);

    try {
      final result = await repository.resetPassword(
        email: email,
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
}
