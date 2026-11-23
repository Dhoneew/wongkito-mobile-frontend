import 'package:flutter/foundation.dart';

class MenuDetailViewModel extends ChangeNotifier {
  String? _sugarLevel;
  bool? _extraShot;
  String? _temperature;

  String _orderType = 'Dine-in (Makan di Tempat)';
  String _tableNumber = 'Meja 05';

  int _quantity = 0;
  final int basePrice;

  MenuDetailViewModel({required this.basePrice});

  String? get sugarLevel => _sugarLevel;
  bool? get extraShot => _extraShot;
  String? get temperature => _temperature;

  String get orderType => _orderType;
  String get tableNumber => _tableNumber;

  int get quantity => _quantity;

  int get unitPrice => basePrice + (_extraShot == true ? 5000 : 0);

  int get subtotal => _quantity * unitPrice;

  void selectSugarLevel(String value) {
    _sugarLevel = value;
    notifyListeners();
  }

  void selectExtraShot(bool value) {
    _extraShot = value;
    notifyListeners();
  }

  void selectTemperature(String value) {
    _temperature = value;
    notifyListeners();
  }

  void selectOrderType(String value) {
    _orderType = value;
    notifyListeners();
  }

  void selectTableNumber(String value) {
    _tableNumber = value;
    notifyListeners();
  }

  String? validateOrder() {
    if (_sugarLevel == null) {
      return 'Silakan pilih level gula';
    }

    if (_temperature == null) {
      return 'Silakan pilih suhu penyajian';
    }

    if (_quantity <= 0) {
      return 'Silakan tambahkan jumlah pesanan minimal 1';
    }

    if (_orderType == 'Dine-in (Makan di Tempat)' &&
        _tableNumber.trim().isEmpty) {
      return 'Silakan pilih nomor meja';
    }

    return null;
  }

  void increaseQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 0) {
      _quantity--;
      notifyListeners();
    }
  }
}
