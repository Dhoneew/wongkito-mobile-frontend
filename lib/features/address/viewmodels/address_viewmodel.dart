import 'package:flutter/foundation.dart';

import '../models/address.dart';
import '../repositories/address_repository.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressRepository repository;

  AddressViewModel(this.repository);

  /// Satu instance bersama supaya alamat tidak hilang saat halaman dibuka ulang.
  static final AddressViewModel shared = AddressViewModel(AddressRepository());

  List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  void loadAddresses() {
    _addresses = repository.getAddresses();
    notifyListeners();
  }

  void addAddress(Address address) {
    repository.addAddress(address);
    loadAddresses();
  }

  void updateAddress(Address address) {
    repository.updateAddress(address);
    loadAddresses();
  }

  void deleteAddress(String id) {
    repository.deleteAddress(id);
    loadAddresses();
  }

  void setPrimaryAddress(String id) {
    repository.setPrimaryAddress(id);
    loadAddresses();
  }

  void reset() {
    repository.reset();
    loadAddresses();
  }
}
