import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/viewmodels/auth_viewmodel.dart';

import 'package:flutter/material.dart';

import '../../theme/wkm_style.dart';
import 'login_page.dart';

// ==========================================
// STEP 1: LUPA PASSWORD (INPUT EMAIL)
// ==========================================
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  static const Color orange = WkmColors.orange;
  static const Color dark = WkmColors.dark;
  static const Color bg = WkmColors.background;
  static const Color grey = WkmColors.muted;

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AuthViewModel viewModel;

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
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendLink() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final success = await viewModel.sendResetLink(_emailController.text.trim());

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.errorMessage ?? 'Gagal mengirim link reset password.',
          ),
          backgroundColor: WkmColors.danger,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          viewModel.successMessage ??
              'Link reset berhasil disiapkan (simulasi).',
        ),
        backgroundColor: WkmColors.success,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResetPasswordPage(email: _emailController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: wkmBackButton(() => Navigator.pop(context)),
        titleSpacing: 0,
        title: const Text(
          'Lupa Password',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // Subtitle petunjuk
                const Text(
                  'Masukkan email kamu untuk\nmenerima link reset password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                // Field Input Email
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: WkmColors.orange, width: 1.2),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: dark,
                    ),
                    validator: (val) => viewModel.validateEmail(val ?? ''),
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: WkmColors.muted,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: WkmColors.orange,
                        size: 20,
                      ),
                      errorStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: WkmColors.danger,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tombol Kirim Link
                wkmPrimaryButton(
                  label: 'Kirim Link',
                  onPressed: _sendLink,
                  loading: viewModel.isLoading,
                  height: 48,
                ),

                const SizedBox(height: 48),

                // Ilustrasi Lingkaran Amplop Oranye (Persis Gambar)
                Container(
                  width: 170,
                  height: 170,
                  decoration: const BoxDecoration(
                    color: WkmColors.softOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 60,
                      decoration: BoxDecoration(
                        color: orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: const Size(90, 60),
                            painter: _EnvelopePainter(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Keterangan di bawah ilustrasi
                const Text(
                  'Kami akan mengirimkan link reset\nke email kamu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// STEP 2: RESET PASSWORD (INPUT PASSWORD BARU)
// ==========================================
class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  static const Color dark = WkmColors.dark;
  static const Color bg = WkmColors.background;
  static const Color grey = WkmColors.muted;

  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _resetFormKey = GlobalKey<FormState>();

  late final AuthViewModel viewModel;

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

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
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // Live validations melalui ViewModel
  bool get _hasMin8Chars => _passwordController.text.length >= 8;

  bool get _hasLetterAndNumber =>
      viewModel.isPasswordStrong(_passwordController.text);

  bool get _isConfirmed => viewModel.passwordsMatch(
    _passwordController.text,
    _confirmController.text,
  );

  Future<void> _savePassword() async {
    FocusScope.of(context).unfocus();

    // Inline validator dan checklist di bawah field sudah menjelaskan
    // masalahnya; SnackBar duplikat hanya menambah noise.
    if (!(_resetFormKey.currentState?.validate() ?? false)) return;
    if (!viewModel.isPasswordStrong(_passwordController.text)) return;
    if (!viewModel.passwordsMatch(
      _passwordController.text,
      _confirmController.text,
    )) {
      return;
    }

    FocusScope.of(context).unfocus();

    final success = await viewModel.resetPassword(
      email: widget.email,
      newPassword: _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Gagal mereset password.'),
          backgroundColor: WkmColors.danger,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ResetSuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: wkmBackButton(() => Navigator.pop(context)),
        titleSpacing: 0,
        title: const Text(
          'Reset Password',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 28,
            bottom: 28 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _resetFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // INPUT 1: PASSWORD
                _buildInputField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.key,
                  obscureText: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password baru wajib diisi';
                    }
                    if (!viewModel.isPasswordStrong(value)) {
                      return 'Minimal 8 karakter, huruf, dan angka';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 14),

                // INPUT 2: KONFIRMASI PASSWORD BARU
                _buildInputField(
                  controller: _confirmController,
                  hintText: 'Konfirmasi password baru',
                  icon: Icons.key,
                  obscureText: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password wajib diisi';
                    }
                    if (!viewModel.passwordsMatch(
                      _passwordController.text,
                      value,
                    )) {
                      return 'Konfirmasi password tidak cocok';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // CHECKLIST VALIDASI PASSWORD
                const Text(
                  'Password harus terdiri dari:',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: grey,
                  ),
                ),

                const SizedBox(height: 10),

                _buildChecklistItem(
                  title: 'Minimal 8 karakter',
                  isValid: _hasMin8Chars,
                ),
                const SizedBox(height: 6),
                _buildChecklistItem(
                  title: 'Mengandung huruf dan angka',
                  isValid: _hasLetterAndNumber,
                ),
                const SizedBox(height: 6),
                _buildChecklistItem(
                  title: 'Konfirmasi password baru cocok',
                  isValid: _isConfirmed,
                ),

                const SizedBox(height: 40),

                // TOMBOL SIMPAN PASSWORD
                wkmPrimaryButton(
                  label: 'Simpan Password',
                  onPressed: _savePassword,
                  loading: viewModel.isLoading,
                  height: 48,
                ),
              ],
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
    required bool obscureText,
    required VoidCallback onToggle,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WkmColors.orange, width: 1.2),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        textInputAction: TextInputAction.next,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: dark),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: WkmColors.muted,
          ),
          prefixIcon: Icon(icon, color: WkmColors.orange, size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: WkmColors.muted,
              size: 18,
            ),
            onPressed: onToggle,
          ),
          errorStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: WkmColors.danger,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistItem({required String title, required bool isValid}) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: 18,
          color: isValid ? WkmColors.success : WkmColors.disabled,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: isValid ? dark : WkmColors.muted,
            fontWeight: isValid ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ==========================================
// STEP 3: BERHASIL RESET (SUKSES)
// ==========================================
class ResetSuccessPage extends StatelessWidget {
  const ResetSuccessPage({super.key});

  static const Color orange = WkmColors.orange;
  static const Color dark = WkmColors.dark;
  static const Color bg = WkmColors.background;
  static const Color grey = WkmColors.muted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // LINGKARAN BESAR CENTANG HIJAU
              Container(
                width: 190,
                height: 190,
                decoration: const BoxDecoration(
                  color: WkmColors.successSoft,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      color: WkmColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 72,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // JUDUL SUKSES
              const Text(
                'Password Berhasil Diubah (Simulasi)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),

              const SizedBox(height: 8),

              // SUBTITLE
              const Text(
                'Untuk demo, login menerima email dan kata sandi\napa pun yang valid.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: grey,
                  height: 1.4,
                ),
              ),

              const Spacer(flex: 3),

              // TOMBOL KEMBALI KE LOGIN
              Center(
                child: SizedBox(
                  width: 200,
                  child: wkmPrimaryButton(
                    label: 'Kembali ke Login',
                    onPressed: () {
                      // Bersihkan stack reset password supaya tombol back
                      // tidak membawa user kembali ke halaman lupa password.
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// PAINTER AMPLOP UNTUK ILUSTRASI LUPA PASSWORD
class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Garis lipatan atas amplop membentuk huruf V
    path.moveTo(4, 4);
    path.lineTo(size.width / 2, size.height * 0.65);
    path.lineTo(size.width - 4, 4);

    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
