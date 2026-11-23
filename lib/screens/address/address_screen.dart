
import 'package:flutter/material.dart';
import '../../features/address/models/address.dart';
import '../../features/address/repositories/address_repository.dart';
import '../../features/address/viewmodels/address_viewmodel.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  static const Color orange = Color(0xFFFF6200);
  static const Color backgroundColor = Color(0xFFFAF9F9);
  static const Color textColor = Color(0xFF1A1C1C);

  late final AddressViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AddressViewModel(AddressRepository());
    viewModel.loadAddresses();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
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
        builder: (context, child) {
          final addresses = viewModel.addresses;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...addresses.map((address) {
                return _buildAddressItem(address);
              }),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _showAddressForm,
                icon: const Icon(Icons.add, color: orange),
                label: const Text(
                  'Tambah Alamat',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: orange,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: orange),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isPrimary ? orange : const Color(0xFFEAEAEA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address.label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              if (address.isPrimary)
                const Text(
                  'Utama',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: orange,
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
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            address.phoneNumber,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            address.fullAddress,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: textColor,
            ),
          ),
          const Divider(height: 24),
          Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: () => _showAddressForm(address: address),
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  viewModel.setPrimaryAddress(address.id);
                },
                child: const Text('Jadikan Utama'),
              ),
              TextButton(
                onPressed: () => viewModel.deleteAddress(address.id),
                child: const Text(
                  'Hapus',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddressForm({Address? address}) {
    final nameController = TextEditingController(
      text: address?.recipientName ?? '',
    );
    final phoneController = TextEditingController(
      text: address?.phoneNumber ?? '',
    );
    final addressController = TextEditingController(
      text: address?.fullAddress ?? '',
    );
    final labelController = TextEditingController(
      text: address?.label ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(address == null ? 'Tambah Alamat' : 'Edit Alamat'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Nama Penerima'),
                _buildTextField(phoneController, 'Nomor Telepon'),
                _buildTextField(addressController, 'Alamat Lengkap'),
                _buildTextField(labelController, 'Label (Rumah/Kantor)'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    phoneController.text.trim().isEmpty ||
                    addressController.text.trim().isEmpty ||
                    labelController.text.trim().isEmpty) {
                  return;
                }

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
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      phoneController.dispose();
      addressController.dispose();
      labelController.dispose();
    });
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
