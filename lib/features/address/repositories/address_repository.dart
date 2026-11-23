import '../models/address.dart';

class AddressRepository {
  final List<Address> _addresses = [
    const Address(
      id: '1',
      recipientName: 'Valentino',
      phoneNumber: '081234567890',
      fullAddress: 'Malang, Jawa Timur',
      label: 'Rumah',
      isPrimary: true,
    ),
  ];

  List<Address> getAddresses() {
    return List.unmodifiable(_addresses);
  }

  void addAddress(Address address) {
    _addresses.add(address);
  }

  void updateAddress(Address updatedAddress) {
    final index = _addresses.indexWhere(
      (address) => address.id == updatedAddress.id,
    );

    if (index != -1) {
      _addresses[index] = updatedAddress;
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((address) => address.id == id);
  }

  void setPrimaryAddress(String id) {
    for (int i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isPrimary: _addresses[i].id == id);
    }
  }
}
