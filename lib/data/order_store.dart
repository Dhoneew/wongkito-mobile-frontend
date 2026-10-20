
import 'package:flutter/foundation.dart';

class CartItem {
  final String menuName;
  final String menuImage;
  final int price;
  final String sugarLevel;
  final bool extraShot;
  final String temperature;
  int quantity;

  CartItem({
    required this.menuName,
    required this.menuImage,
    required this.price,
    required this.sugarLevel,
    required this.extraShot,
    required this.temperature,
    required this.quantity,
  });

  int get subtotal => quantity * (price + (extraShot ? 5000 : 0));
}

class OrderStore extends ChangeNotifier {
  OrderStore._();

  static final OrderStore instance = OrderStore._();

  final List<CartItem> cart = [];
  final List<Map<String, dynamic>> orders = [];

  String orderType = 'Dine-in';
  String tableNumber = 'Meja 05';
  String paymentMethod = 'QRIS';
  String kitchenNote = '';

  int get cartTotal =>
      cart.fold(0, (total, item) => total + item.subtotal);

  int get cartQuantity =>
      cart.fold(0, (total, item) => total + item.quantity);

  void addItem(CartItem item) {
    cart.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    cart.remove(item);
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    if (!cart.contains(item)) return;

    if (quantity <= 0) {
      cart.remove(item);
    } else {
      item.quantity = quantity;
    }

    notifyListeners();
  }

  void checkout() {
    if (cart.isEmpty) return;

    final id = 'WK-${(orders.length + 1).toString().padLeft(3, '0')}';

    orders.insert(0, {
      'id': id,
      'items': '$cartQuantity Item',
      'price': cartTotal,
      'date': DateTime.now().toString().substring(0, 16),
      'status': 'Sedang Diproses',
      'orderType': orderType,
      'tableNumber': tableNumber,
      'paymentMethod': paymentMethod,
      'note': kitchenNote,
      'details': cart.map((item) => {
        'menuName': item.menuName,
        'menuImage': item.menuImage,
        'price': item.price,
        'quantity': item.quantity,
        'sugarLevel': item.sugarLevel,
        'extraShot': item.extraShot,
        'temperature': item.temperature,
        'subtotal': item.subtotal,
      }).toList(),
    });

    cart.clear();
    kitchenNote = '';
    notifyListeners();
  }
}
