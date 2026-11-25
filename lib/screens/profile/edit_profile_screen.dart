import 'package:flutter/material.dart';

import '../../features/profile/repositories/profile_repository.dart';
import '../../features/profile/viewmodels/profile_viewmodel.dart';
import '../../theme/wkm_style.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ProfileViewModel viewModel;

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    viewModel = ProfileViewModel(ProfileRepository.instance);
    viewModel.loadProfile();

    final profile = viewModel.profile;
    _nameController.text = profile?.name ?? '';
    _usernameController.text = profile?.username ?? '';
    _emailController.text = profile?.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WkmColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: WkmColors.background,
        foregroundColor: WkmColors.dark,
        elevation: 0,
        leading: wkmBackButton(() => Navigator.pop(context)),
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: WkmColors.softOrange,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 57,
                        backgroundColor: WkmColors.softOrange,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: WkmColors.orange,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        tooltip: 'Info foto profil',
                        onPressed: _showPhotoInfo,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: WkmColors.orange,
                          side: const BorderSide(color: Colors.white, width: 2),
                          minimumSize: const Size(44, 44),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Foto profil belum tersedia pada versi demo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: WkmColors.muted,
                ),
              ),
              const SizedBox(height: 24),

              // NAMA LENGKAP
              _buildTextField(
                controller: _nameController,
                labelText: 'Nama Lengkap',
                hintText: 'Nama Lengkap',
                prefixIcon: Icons.badge_outlined,
                textInputAction: TextInputAction.next,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Nama wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),

              // USERNAME
              _buildTextField(
                controller: _usernameController,
                labelText: 'Username',
                hintText: 'Username',
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Username wajib diisi'
                    : null,
              ),
              const SizedBox(height: 16),

              // EMAIL
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return 'Email wajib diisi';
                  if (!ProfileViewModel.emailPattern.hasMatch(email)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // PASSWORD (opsional, kosongkan jika tidak diubah)
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password Baru (opsional)',
                hintText: 'Password Baru (opsional)',
                prefixIcon: Icons.key,
                isPassword: true,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                onToggleObscure: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  if (value.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // KONFIRMASI PASSWORD
              _buildTextField(
                controller: _confirmPasswordController,
                labelText: 'Konfirmasi Password Baru',
                hintText: 'Konfirmasi Password Baru',
                prefixIcon: Icons.key,
                isPassword: true,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                onToggleObscure: () {
                  setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  );
                },
                validator: (value) {
                  if (_passwordController.text.isEmpty) {
                    return (value == null || value.isEmpty)
                        ? null
                        : 'Isi password baru terlebih dahulu';
                  }
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password wajib diisi';
                  }
                  if (value != _passwordController.text) {
                    return 'Konfirmasi password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              wkmPrimaryButton(
                label: 'Simpan Perubahan',
                onPressed: _saveProfile,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoInfo() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Foto Profil',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Foto profil belum tersedia pada versi demo.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Mengerti'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: isPassword ? obscureText : false,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: WkmColors.dark,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: WkmColors.muted,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: WkmColors.muted,
        ),
        prefixIcon: Icon(prefixIcon, color: WkmColors.orange, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: WkmColors.muted,
                  size: 20,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        errorStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          color: WkmColors.danger,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: WkmColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: WkmColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: WkmColors.orange),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();

    // Error inline sudah tampil di masing-masing field; tidak perlu SnackBar
    // generik yang mengulang pesan yang sama.
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final wantsPasswordChange = _passwordController.text.isNotEmpty;

    final error = viewModel.updateProfile(
      name: _nameController.text,
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: WkmColors.danger),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wantsPasswordChange
              ? 'Profil berhasil diperbarui. Ganti password masih simulasi lokal dan belum tersimpan.'
              : 'Profil berhasil diperbarui',
        ),
        backgroundColor: WkmColors.success,
      ),
    );

    Navigator.pop(context);
  }
}
