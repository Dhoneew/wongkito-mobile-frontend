import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';

import 'package:flutter/material.dart';

import '../../theme/wkm_style.dart';
import '../../main.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color _orange = WkmColors.orange;
  static const Color _bg = WkmColors.background;
  static const Color _text = WkmColors.dark;
  static const Color _grey = WkmColors.muted;
  static const Color _border = WkmColors.border;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthViewModel viewModel;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    viewModel = AuthViewModel(AuthRepository());
    viewModel.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    viewModel.removeListener(_onAuthChanged);
    viewModel.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // LOGIN MELALUI VIEWMODEL

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final success = await viewModel.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      // Email sengaja dipertahankan agar user tidak mengetik ulang.
      // Password disembunyikan kembali setelah error walaupun sebelumnya
      // user menekan ikon mata.
      setState(() => _obscurePassword = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Login gagal.'),
          backgroundColor: WkmColors.danger,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(viewModel.successMessage ?? 'Login berhasil!'),
        backgroundColor: WkmColors.success,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        color: _grey,
      ),
      prefixIcon: Icon(icon, size: 20, color: _grey),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      enabledBorder: border(_border),
      focusedBorder: border(_orange, 1.5),
      errorBorder: border(WkmColors.danger),
      focusedErrorBorder: border(WkmColors.danger, 1.5),
      errorStyle: const TextStyle(fontFamily: 'Inter', fontSize: 11),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              24 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/Logo ada nama.png',
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.local_cafe,
                          size: 80,
                          color: _orange,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Selamat Datang!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _text,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Masuk untuk mulai memesan makanan\n'
                    'dan minuman favoritmu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: _text,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // EMAIL
                  _label('Email'),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 13),
                    decoration: _inputDecoration(
                      hint: 'nama@email.com',
                      icon: Icons.mail_outline,
                    ),
                    validator: (value) => viewModel.validateEmail(value ?? ''),
                  ),

                  const SizedBox(height: 16),

                  // KATA SANDI
                  _label('Kata Sandi'),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    onFieldSubmitted: (_) => _login(),
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 13),
                    decoration: _inputDecoration(
                      hint: 'Masukkan kata sandi',
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: _grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) =>
                        viewModel.validatePassword(value ?? ''),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Lupa kata sandi?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: _orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // TOMBOL MASUK
                  wkmPrimaryButton(
                    label: 'Masuk',
                    onPressed: _login,
                    loading: viewModel.isLoading,
                    height: 48,
                  ),

                  const SizedBox(height: 20),

                  // PEMBATAS
                  const Row(
                    children: [
                      Expanded(child: Divider(color: _border)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'atau',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: _grey,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: _border)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // GOOGLE: SIMULASI
                  SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Login Google masih simulasi. Untuk demo, '
                              'gunakan email dan kata sandi apa pun yang valid.',
                            ),
                          ),
                        );
                      },
                      icon: const Text(
                        'G',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFFDB4437),
                        ),
                      ),
                      label: const Text(
                        'Masuk dengan Google',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _text,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: _border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // DAFTAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: _text,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 12,
                          ),
                          minimumSize: const Size(40, 44),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _orange,
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
}
