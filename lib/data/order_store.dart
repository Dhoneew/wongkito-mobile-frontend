
import 'package:flutter/foundation.dart';

import '../features/orders/models/cart_item.dart';
import '../features/orders/models/order.dart';
import '../features/orders/repositories/order_repository.dart';
import '../features/orders/viewmodels/order_viewmodel.dart';

class OrderStore extends ChangeNotifier {
  OrderStore._(this.viewModel) {
    viewModel.addListener(notifyListeners);
  }

  // Satu repository untuk seluruh aplikasi.
  static final OrderRepository _repository = OrderRepository();

  // Satu ViewModel yang digunakan bersama.
  static final OrderViewModel _sharedViewModel =
      OrderViewModel(_repository);

  static final OrderStore instance =
      OrderStore._(_sharedViewModel);

  final OrderViewModel viewModel;

  // Getters
  List<CartItem> get cart => viewModel.cart;
  List<Order> get orders => viewModel.orders;

  String get orderType => viewModel.orderType;
  set orderType(String value) => viewModel.setOrderType(value);

  String get tableNumber => viewModel.tableNumber;
  set tableNumber(String value) => viewModel.setTableNumber(value);

  String get paymentMethod => viewModel.paymentMethod;
  set paymentMethod(String value) =>
      viewModel.setPaymentMethod(value);

  String get kitchenNote => viewModel.kitchenNote;
  set kitchenNote(String value) =>
      viewModel.setKitchenNote(value);

  int get cartTotal => viewModel.cartTotal;
  int get cartQuantity => viewModel.cartQuantity;

  // Actions
  void setOrderType(String type) =>
      viewModel.setOrderType(type);

  void setTableNumber(String table) =>
      viewModel.setTableNumber(table);

  void setPaymentMethod(String method) =>
      viewModel.setPaymentMethod(method);

  void setKitchenNote(String note) =>
      viewModel.setKitchenNote(note);

  void refresh() => viewModel.refresh();

  void addItem(CartItem item) =>
      viewModel.addItem(item);

  void removeItem(CartItem item) =>
      viewModel.removeItem(item);

  void updateQuantity(CartItem item, int quantity) =>
      viewModel.updateQuantity(item, quantity);

  void updateItemNote(CartItem item, String note) =>
      viewModel.updateItemNote(item, note);

  String? checkout() => viewModel.checkout();

  bool cancelOrder(String orderId) => viewModel.cancelOrder(orderId);

  bool markOrderPaid(String orderId) => viewModel.markOrderPaid(orderId);

  @override
  void dispose() {
    viewModel.removeListener(notifyListeners);
    super.dispose();
  }
}
