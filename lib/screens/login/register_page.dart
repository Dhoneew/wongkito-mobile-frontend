import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';

import 'package:flutter/material.dart';

import '../../theme/wkm_style.dart';
import '../../main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const Color orange = WkmColors.orange;
  static const Color primaryOrange = WkmColors.orange;
  static const Color bg = WkmColors.background;
  static const Color dark = WkmColors.dark;
  static const Color grey = WkmColors.muted;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AuthViewModel viewModel;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    viewModel = AuthViewModel(AuthRepository());
    viewModel.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    viewModel.removeListener(_onAuthChanged);
    viewModel.dispose();

    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    // Validator inline sudah menunjukkan ketidakcocokan di bawah field.
    // Cegah submit tanpa menambah SnackBar yang sama seperti notifikasi.
    if (_passwordController.text != _confirmPasswordController.text) return;

    FocusScope.of(context).unfocus();

    final success = await viewModel.register(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Registrasi gagal.'),
          backgroundColor: WkmColors.danger,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          viewModel.successMessage ??
              'Akun berhasil dibuat! Selamat datang di Warkop Wong Kito.',
        ),
        backgroundColor: WkmColors.success,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 28,
              right: 28,
              top: 20,
              bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO WKM
                  Image.asset(
                    'assets/images/Logo ada nama.png',
                    height: 100,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.local_cafe, size: 80, color: orange),
                  ),

                  const SizedBox(height: 20),

                  // JUDUL
                  const Text(
                    'Buat Akun',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // INPUT 1: USERNAME
                  _buildInputField(
                    controller: _usernameController,
                    hintText: 'Nama Pengguna',
                    icon: Icons.person,
                    validator: (val) => viewModel.validateUsername(val ?? ''),
                  ),

                  const SizedBox(height: 14),

                  // INPUT 2: EMAIL
                  _buildInputField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => viewModel.validateEmail(val ?? ''),
                  ),

                  const SizedBox(height: 14),

                  // INPUT 3: PASSWORD
                  _buildInputField(
                    controller: _passwordController,
                    hintText: 'Kata Sandi',
                    icon: Icons.key,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onToggleVisibility: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    validator: (val) => viewModel.validatePassword(val ?? ''),
                  ),

                  const SizedBox(height: 14),

                  // INPUT 4: CONFIRM PASSWORD
                  _buildInputField(
                    controller: _confirmPasswordController,
                    hintText: 'Konfirmasi Kata Sandi',
                    icon: Icons.key,
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    onToggleVisibility: () {
                      setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Konfirmasi password wajib diisi';
                      }
                      if (!viewModel.passwordsMatch(
                        _passwordController.text,
                        val,
                      )) {
                        return 'Konfirmasi password tidak cocok';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 22),

                  // TOMBOL SIGN UP
                  wkmPrimaryButton(
                    label: 'Daftar',
                    onPressed: _signUp,
                    loading: viewModel.isLoading,
                    height: 48,
                  ),

                  const SizedBox(height: 18),

                  // OR WITH
                  const Text(
                    'atau dengan',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: grey,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // SOCIAL ICONS (Google & Facebook)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Daftar Google masih simulasi. Untuk demo, '
                                'gunakan formulir pendaftaran.',
                              ),
                              duration: Duration(seconds: 4),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: WkmColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'G',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader =
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFF4285F4),
                                          Color(0xFFEA4335),
                                          Color(0xFFFBBC05),
                                          Color(0xFF34A853),
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(
                                          0.0,
                                          0.0,
                                          24.0,
                                          24.0,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Facebook
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Daftar Facebook masih simulasi. Untuk demo, '
                                'gunakan formulir pendaftaran.',
                              ),
                              duration: Duration(seconds: 4),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1877F2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1877F2)
                                    .withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'f',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // FOOTER SUDAH PUNYA AKUN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: dark,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 12,
                          ),
                          minimumSize: const Size(40, 44),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WkmColors.orange, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: dark),
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: grey,
          ),
          prefixIcon: Icon(icon, color: WkmColors.orange, size: 19),
          errorStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: WkmColors.danger,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: grey,
                    size: 18,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
