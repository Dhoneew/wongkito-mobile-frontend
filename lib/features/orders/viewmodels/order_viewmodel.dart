import 'package:flutter/foundation.dart';

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

  List<Order> get visibleOrders {
    return _selectedTab == 0
        ? repository.getOrdersByStatus('Sedang Diproses')
        : repository.getOrdersByStatus('Selesai');
  }

  int get processingCount =>
      repository.getOrderCountByStatus('Sedang Diproses');

  int get historyCount => repository.getOrderCountByStatus('Selesai');

  void selectOrderTab(int index) {
    if (_selectedTab == index) return;

    _selectedTab = index;
    notifyListeners();
  }

  String rupiah(int value) {
    return 'Rp${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

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

  // ORDER SETTINGS

  void setOrderType(String value) {
    repository.setOrderType(value);
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
}
