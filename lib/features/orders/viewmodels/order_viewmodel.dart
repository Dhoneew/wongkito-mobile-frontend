import 'package:flutter/foundation.dart';

import '../../../theme/wkm_style.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository repository;

  OrderViewModel(this.repository);

  // CART DATA

  List<CartItem> get cart => repository.cart;
  List<Order> get orders => repository.orders;

  String get orderType => repository.orderType;
  String get tableNumber => repository.tableNumber;
  String get paymentMethod => repository.paymentMethod;
  String get kitchenNote => repository.kitchenNote;

  int get cartTotal => repository.cartTotal;
  int get cartQuantity => repository.cartQuantity;

  // ORDER HISTORY

  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  List<Order> get allOrders => repository.allOrders;

  Order? getOrderById(String id) => repository.getOrderById(id);

  /// Tab "Dalam Proses" mencakup semua status sebelum Selesai, termasuk
  /// "Siap Diantar", supaya pesanan tidak hilang saat status disimulasikan.
  List<Order> get visibleOrders {
    if (_selectedTab == 1) return repository.getOrdersByStatus('Selesai');
    return repository.allOrders
        .where((order) => order.status != 'Selesai')
        .toList();
  }

  int get processingCount =>
      repository.allOrders.where((order) => order.status != 'Selesai').length;

  int get historyCount => repository.getOrderCountByStatus('Selesai');

  void selectOrderTab(int index) {
    if (_selectedTab == index) return;

    _selectedTab = index;
    notifyListeners();
  }

  String rupiah(int value) => wkmRupiah(value);

  // CART ACTIONS

  void addItem(CartItem item) {
    repository.addItem(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    repository.removeItem(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    repository.updateQuantity(item, quantity);
    notifyListeners();
  }

  void updateItemNote(CartItem item, String note) {
    repository.updateItemNote(item, note);
    notifyListeners();
  }

  // ORDER SETTINGS

  void setOrderType(String value) {
    final normalized = value.startsWith('Dine-in')
        ? 'Dine-in'
        : value.startsWith('Take Away')
            ? 'Take Away'
            : value;

    repository.setOrderType(normalized);
    // Take Away tidak memakai nomor meja. Bersihkan state lama supaya tidak
    // terbawa ke checkout/detail pesanan berikutnya.
    if (normalized == 'Take Away') {
      repository.setTableNumber('');
    } else if (repository.tableNumber.trim().isEmpty) {
      repository.setTableNumber('Meja 05');
    }
    notifyListeners();
  }

  void setTableNumber(String value) {
    repository.setTableNumber(value);
    notifyListeners();
  }

  void setPaymentMethod(String value) {
    repository.setPaymentMethod(value);
    notifyListeners();
  }

  void setKitchenNote(String value) {
    repository.setKitchenNote(value);
    notifyListeners();
  }

  // CHECKOUT

  String? checkout() {
    final orderId = repository.checkout();
    notifyListeners();
    return orderId;
  }

  void refresh() {
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    repository.updateOrderStatus(orderId, newStatus);
    notifyListeners();
  }

  bool markOrderPaid(String orderId) {
    final paid = repository.markOrderPaid(orderId);
    if (paid) notifyListeners();
    return paid;
  }

  bool cancelOrder(String orderId) {
    final cancelled = repository.cancelOrder(orderId);
    if (cancelled) notifyListeners();
    return cancelled;
  }
}
