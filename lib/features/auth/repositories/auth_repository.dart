import '../models/auth_user.dart';

class AuthRepository {
  AuthRepository._internal();

  static final AuthRepository _instance = AuthRepository._internal();

  factory AuthRepository() => _instance;

  AuthUser? _currentUser;

  AuthUser? get currentUser => _currentUser;

  // LOGIN SIMULASI

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = AuthUser(username: email.split('@').first, email: email);

    return _currentUser!;
  }

  // REGISTER SIMULASI

  Future<AuthUser> register({
    required String username,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = AuthUser(username: username, email: email);

    return _currentUser!;
  }

  // FORGOT PASSWORD SIMULASI

  Future<bool> sendResetLink(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  // RESET PASSWORD SIMULASI

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return true;
  }

  // LOGOUT

  void logout() {
    _currentUser = null;
  }
}
