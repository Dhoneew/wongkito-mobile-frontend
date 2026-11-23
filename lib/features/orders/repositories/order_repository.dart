import '../models/cart_item.dart';
import '../models/order.dart';

class OrderRepository {
  final List<CartItem> _cart = [];
  final List<Order> _orders = [];
  int _orderCounter = 100;

  String _orderType = 'Dine-in';
  String _tableNumber = 'Meja 05';
  String _paymentMethod = 'QRIS';
  String _kitchenNote = '';

  // MOCK ORDER HISTORY

  final List<Order> _sampleOrders = [
    Order(
      id: 'WK-001',
      items: '2 Item',
      price: 61000,
      date: '28 September 2026',
      status: 'Sedang Diproses',
      orderType: 'Dine-in',
      tableNumber: 'Meja 05',
      paymentMethod: '',
      note: '',
      details: [],
    ),
    Order(
      id: 'WK-002',
      items: '1 Item',
      price: 18000,
      date: '25 September 2026',
      status: 'Selesai',
      orderType: 'Dine-in',
      tableNumber: 'Meja 05',
      paymentMethod: '',
      note: '',
      details: [],
    ),
    Order(
      id: 'WK-003',
      items: '2 Item',
      price: 30000,
      date: '29 September 2026',
      status: 'Selesai',
      orderType: 'Dine-in',
      tableNumber: 'Meja 05',
      paymentMethod: '',
      note: '',
      details: [],
    ),
    Order(
      id: 'WK-004',
      items: '1 Item',
      price: 12000,
      date: '28 September 2026',
      status: 'Selesai',
      orderType: 'Dine-in',
      tableNumber: 'Meja 05',
      paymentMethod: '',
      note: '',
      details: [],
    ),
    Order(
      id: 'WK-011',
      items: '2 Item',
      price: 20000,
      date: '28 September 2026',
      status: 'Selesai',
      orderType: 'Dine-in',
      tableNumber: 'Meja 05',
      paymentMethod: '',
      note: '',
      details: [],
    ),
  ];

  // GETTERS

  List<CartItem> get cart => _cart;

  List<Order> get orders => _orders;

  List<Order> get allOrders {
    final liveOrderIds = _orders.map((order) => order.id).toSet();

    return [
      ..._orders,
      ..._sampleOrders.where((order) => !liveOrderIds.contains(order.id)),
    ];
  }

  String get orderType => _orderType;
  String get tableNumber => _tableNumber;
  String get paymentMethod => _paymentMethod;
  String get kitchenNote => _kitchenNote;

  int get cartTotal {
    return _cart.fold(0, (total, item) => total + item.subtotal);
  }

  int get cartQuantity {
    return _cart.fold(0, (total, item) => total + item.quantity);
  }

  // ORDER FILTERS

  List<Order> getOrdersByStatus(String status) {
    return allOrders.where((order) => order.status == status).toList();
  }

  int getOrderCountByStatus(String status) {
    return getOrdersByStatus(status).length;
  }

  // SETTERS

  void setOrderType(String type) {
    _orderType = type;
  }

  void setTableNumber(String table) {
    _tableNumber = table;
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
  }

  void setKitchenNote(String note) {
    _kitchenNote = note;
  }

  // CART OPERATIONS

  void addItem(CartItem item) {
    _cart.add(item);
  }

  void removeItem(CartItem item) {
    _cart.remove(item);
  }

  void updateQuantity(CartItem item, int quantity) {
    if (!_cart.contains(item)) return;

    if (quantity <= 0) {
      _cart.remove(item);
    } else {
      item.quantity = quantity;
    }
  }

  // ORDER OPERATIONS

  String? checkout() {
    if (_cart.isEmpty) return null;

    _orderCounter++;

    final orderId = 'WK-${_orderCounter.toString().padLeft(3, '0')}';

    final newOrder = Order(
      id: orderId,
      items: '$cartQuantity Item',
      price: cartTotal,
      date: DateTime.now().toString().substring(0, 16),
      status: 'Sedang Diproses',
      orderType: _orderType,
      tableNumber: _tableNumber,
      paymentMethod: _paymentMethod,
      note: _kitchenNote,
      details: _cart.map((item) {
        return {
          'menuName': item.menuName,
          'menuImage': item.menuImage,
          'price': item.price,
          'quantity': item.quantity,
          'sugarLevel': item.sugarLevel,
          'extraShot': item.extraShot,
          'temperature': item.temperature,
          'subtotal': item.subtotal,
        };
      }).toList(),
    );

    _orders.insert(0, newOrder);

    _cart.clear();
    _kitchenNote = '';

    return orderId;
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);

    if (index == -1) return;

    final oldOrder = _orders[index];

    _orders[index] = Order(
      id: oldOrder.id,
      items: oldOrder.items,
      price: oldOrder.price,
      date: oldOrder.date,
      status: newStatus,
      orderType: oldOrder.orderType,
      tableNumber: oldOrder.tableNumber,
      paymentMethod: oldOrder.paymentMethod,
      note: oldOrder.note,
      details: oldOrder.details,
    );
  }
}
