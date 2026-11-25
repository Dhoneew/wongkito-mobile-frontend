import 'package:flutter/material.dart';

import '../../features/address/models/address.dart';
import '../../features/address/viewmodels/address_viewmodel.dart';
import '../../theme/wkm_style.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  static final RegExp phonePattern = RegExp(r'^[0-9+\-\s]{8,}$');

  late final AddressViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AddressViewModel.shared;
    viewModel.loadAddresses();
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
          'Alamat Saya',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          final addresses = viewModel.addresses;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (addresses.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_off_outlined,
                        size: 36,
                        color: WkmColors.orange,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Belum ada alamat tersimpan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: WkmColors.dark,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Tambahkan alamat pertama Anda lewat tombol di bawah.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: WkmColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ...addresses.map(_buildAddressItem),
              const SizedBox(height: 12),
              wkmOutlineButton(
                label: 'Tambah Alamat',
                onPressed: () => _showAddressForm(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddressItem(Address address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: wkmCardDecoration(radius: 12).copyWith(
        border: Border.all(
          color: address.isPrimary ? WkmColors.orange : WkmColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: WkmColors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address.label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: WkmColors.dark,
                  ),
                ),
              ),
              if (address.isPrimary)
                const Text(
                  'Utama',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: WkmColors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            address.recipientName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: WkmColors.dark,
            ),
          ),
          Text(
            address.phoneNumber,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: WkmColors.muted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            address.fullAddress,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: WkmColors.dark,
            ),
          ),
          const Divider(height: 24),
          Wrap(
            spacing: 4,
            children: [
              TextButton(
                onPressed: () => _showAddressForm(address: address),
                child: const Text('Edit'),
              ),
              if (!address.isPrimary)
                TextButton(
                  onPressed: () {
                    viewModel.setPrimaryAddress(address.id);
                    _showMessage('Alamat utama berhasil diperbarui.');
                  },
                  child: const Text('Jadikan Utama'),
                ),
              TextButton(
                onPressed: () => _confirmDelete(address),
                child: const Text(
                  'Hapus',
                  style: TextStyle(color: WkmColors.danger),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? WkmColors.danger : WkmColors.success,
      ),
    );
  }

  Future<void> _confirmDelete(Address address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Hapus Alamat?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            address.isPrimary
                ? 'Alamat "${address.label}" adalah alamat utama. Jika dihapus, '
                    'tidak ada alamat yang ditandai sebagai utama.'
                : 'Alamat "${address.label}" akan dihapus dari daftar Anda.',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Hapus',
                style: TextStyle(color: WkmColors.danger),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    viewModel.deleteAddress(address.id);
    _showMessage('Alamat berhasil dihapus.');
  }

  void _showAddressForm({Address? address}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
      text: address?.recipientName ?? '',
    );
    final phoneController = TextEditingController(
      text: address?.phoneNumber ?? '',
    );
    final addressController = TextEditingController(
      text: address?.fullAddress ?? '',
    );
    final labelController = TextEditingController(text: address?.label ?? '');

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: AlertDialog(
            title: Text(
              address == null ? 'Tambah Alamat' : 'Edit Alamat',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(
                      controller: nameController,
                      label: 'Nama Penerima',
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Nama penerima wajib diisi'
                          : null,
                    ),
                    _buildTextField(
                      controller: phoneController,
                      label: 'Nomor Telepon',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        final phone = value?.trim() ?? '';
                        if (phone.isEmpty) return 'Nomor telepon wajib diisi';
                        final digitCount =
                            phone.replaceAll(RegExp(r'[^0-9]'), '').length;
                        if (!phonePattern.hasMatch(phone) || digitCount < 8) {
                          return 'Nomor telepon tidak valid';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: addressController,
                      label: 'Alamat Lengkap',
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Alamat lengkap wajib diisi'
                          : null,
                    ),
                    _buildTextField(
                      controller: labelController,
                      label: 'Label (Rumah/Kantor)',
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Label wajib diisi'
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: WkmColors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  FocusScope.of(dialogContext).unfocus();

                  // Validator inline di dialog sudah cukup; hindari SnackBar
                  // generik yang menutupi pesan error di bawah field.
                  if (!(formKey.currentState?.validate() ?? false)) return;

                  if (address == null) {
                    viewModel.addAddress(
                      Address(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        recipientName: nameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        fullAddress: addressController.text.trim(),
                        label: labelController.text.trim(),
                      ),
                    );
                  } else {
                    viewModel.updateAddress(
                      address.copyWith(
                        recipientName: nameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        fullAddress: addressController.text.trim(),
                        label: labelController.text.trim(),
                      ),
                    );
                  }

                  Navigator.pop(dialogContext);
                  _showMessage(
                    address == null
                        ? 'Alamat berhasil ditambahkan.'
                        : 'Alamat berhasil diperbarui.',
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      nameController.dispose();
      phoneController.dispose();
      addressController.dispose();
      labelController.dispose();
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: WkmColors.dark,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: WkmColors.muted,
          ),
          errorStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: WkmColors.danger,
          ),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WkmColors.orange),
          ),
        ),
      ),
    );
  }
}
