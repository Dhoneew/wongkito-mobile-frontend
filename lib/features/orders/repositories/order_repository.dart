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

  // MOCK ORDER HISTORY — lengkap dengan detail agar tracking tidak sekadar dekorasi.
  final List<Order> _sampleOrders = [
    Order(
      id: 'WK-001',
      items: '2 Item',
      price: 61000,
      date: '28 September 2026',
      status: 'Sedang Diproses',
      orderType: 'Dine-in',
      tableNumber: 'Meja 05',
      paymentMethod: 'QRIS',
      note: 'Es sedikit',
      details: [
        {
          'menuName': 'Kopi Susu Wong Kito',
          'menuImage': 'assets/images/kopi_susu.png',
          'price': 18000,
          'quantity': 2,
          'sugarLevel': 'Normal (100%)',
          'extraShot': false,
          'temperature': 'Ice (Dingin)',
          'subtotal': 36000,
          'note': '',
        },
        {
          'menuName': 'Ayam Geprek Sambal Matah',
          'menuImage': 'assets/images/ayam_geprek.png',
          'price': 25000,
          'quantity': 1,
          'sugarLevel': '-',
          'extraShot': false,
          'temperature': 'Hot (Panas)',
          'subtotal': 25000,
          'note': 'Sambal terpisah',
        },
      ],
    ),
    Order(
      id: 'WK-002',
      items: '1 Item',
      price: 18000,
      date: '25 September 2026',
      status: 'Selesai',
      orderType: 'Take Away',
      tableNumber: '',
      paymentMethod: 'Bayar Kasir (Cash / Tunai)',
      note: '',
      details: [
        {
          'menuName': 'Kopi Susu Wong Kito',
          'menuImage': 'assets/images/kopi_susu.png',
          'price': 18000,
          'quantity': 1,
          'sugarLevel': 'Normal (100%)',
          'extraShot': false,
          'temperature': 'Ice (Dingin)',
          'subtotal': 18000,
          'note': '',
        },
      ],
    ),
    Order(
      id: 'WK-003',
      items: '2 Item',
      price: 30000,
      date: '29 September 2026',
      status: 'Selesai',
      orderType: 'Dine-in',
      tableNumber: 'Meja 03',
      paymentMethod: 'QRIS',
      note: '',
      details: [
        {
          'menuName': 'Matcha Latte',
          'menuImage': 'assets/images/matcha_latte.png',
          'price': 20000,
          'quantity': 1,
          'sugarLevel': 'Half (50%)',
          'extraShot': false,
          'temperature': 'Ice (Dingin)',
          'subtotal': 20000,
          'note': '',
        },
        {
          'menuName': 'Pisang Goreng Keju',
          'menuImage': 'assets/images/ayam_geprek.png',
          'price': 10000,
          'quantity': 1,
          'sugarLevel': '-',
          'extraShot': false,
          'temperature': 'Hot (Panas)',
          'subtotal': 10000,
          'note': '',
        },
      ],
    ),
    Order(
      id: 'WK-004',
      items: '1 Item',
      price: 12000,
      date: '28 September 2026',
      status: 'Selesai',
      orderType: 'Take Away',
      tableNumber: '',
      paymentMethod: 'E-Wallet Langsung',
      note: 'Tanpa gula',
      details: [
        {
          'menuName': 'Kopi Hitam Wong Kito',
          'menuImage': 'assets/images/kopi_susu.png',
          'price': 12000,
          'quantity': 1,
          'sugarLevel': 'Tanpa Gula (0%)',
          'extraShot': false,
          'temperature': 'Hot (Panas)',
          'subtotal': 12000,
          'note': '',
        },
      ],
    ),
    Order(
      id: 'WK-011',
      items: '2 Item',
      price: 20000,
      date: '28 September 2026',
      status: 'Selesai',
      orderType: 'Dine-in',
      tableNumber: 'Meja 08',
      paymentMethod: 'QRIS',
      note: '',
      details: [
        {
          'menuName': 'Pisang Goreng Keju',
          'menuImage': 'assets/images/ayam_geprek.png',
          'price': 15000,
          'quantity': 1,
          'sugarLevel': '-',
          'extraShot': false,
          'temperature': 'Hot (Panas)',
          'subtotal': 15000,
          'note': '',
        },
        {
          'menuName': 'Es Jeruk',
          'menuImage': 'assets/images/kopi_susu.png',
          'price': 5000,
          'quantity': 1,
          'sugarLevel': 'Normal (100%)',
          'extraShot': false,
          'temperature': 'Ice (Dingin)',
          'subtotal': 5000,
          'note': '',
        },
      ],
    ),
  ];

  // GETTERS

  List<CartItem> get cart => _cart;

  List<Order> get orders => _orders;

  Order? getOrderById(String id) {
    for (final order in allOrders) {
      if (order.id == id) return order;
    }
    return null;
  }

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

  void updateItemNote(CartItem item, String note) {
    if (!_cart.contains(item)) return;

    item.note = note;
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
      // QRIS baru dibuat di checkout dan menunggu konfirmasi simulasi.
      // Metode lain dianggap lunas saat pesanan dibuat.
      paymentStatus:
          _paymentMethod == 'QRIS' ? 'Menunggu Pembayaran' : 'Lunas',
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
          'note': item.note,
        };
      }).toList(),
    );

    _orders.insert(0, newOrder);

    _cart.clear();
    _kitchenNote = '';
    // Setelah checkout, kembalikan preferensi ke default untuk pesanan berikutnya.
    _orderType = 'Dine-in';
    _tableNumber = 'Meja 05';
    _paymentMethod = 'QRIS';

    return orderId;
  }

  Order _withStatus(Order order, String newStatus) {
    return Order(
      id: order.id,
      items: order.items,
      price: order.price,
      date: order.date,
      status: newStatus,
      orderType: order.orderType,
      tableNumber: order.tableNumber,
      paymentMethod: order.paymentMethod,
      note: order.note,
      paymentStatus: order.paymentStatus,
      details: order.details,
    );
  }

  /// Menandai simulasi pembayaran QRIS sebagai lunas tanpa membuat pesanan baru.
  bool markOrderPaid(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return false;

    _orders[index] = Order(
      id: _orders[index].id,
      items: _orders[index].items,
      price: _orders[index].price,
      date: _orders[index].date,
      status: _orders[index].status,
      orderType: _orders[index].orderType,
      tableNumber: _orders[index].tableNumber,
      paymentMethod: _orders[index].paymentMethod,
      note: _orders[index].note,
      paymentStatus: 'Lunas',
      details: _orders[index].details,
    );
    return true;
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final liveIndex = _orders.indexWhere((order) => order.id == orderId);
    if (liveIndex != -1) {
      _orders[liveIndex] = _withStatus(_orders[liveIndex], newStatus);
      return;
    }

    final sampleIndex = _sampleOrders.indexWhere((order) => order.id == orderId);
    if (sampleIndex != -1) {
      _sampleOrders[sampleIndex] = _withStatus(_sampleOrders[sampleIndex], newStatus);
    }
  }

  /// Membatalkan pesanan yang belum selesai dan mengembalikan item ke keranjang.
  /// Dipakai saat pengguna membatalkan simulasi pembayaran QRIS.
  bool cancelOrder(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return false;

    final order = _orders[index];
    if (order.status == 'Selesai') return false;

    for (final detail in order.details) {
      _cart.add(
        CartItem(
          menuName: (detail['menuName'] ?? '').toString(),
          menuImage: (detail['menuImage'] ?? '').toString(),
          price: (detail['price'] as num?)?.toInt() ?? 0,
          sugarLevel: (detail['sugarLevel'] ?? 'Normal (100%)').toString(),
          extraShot: detail['extraShot'] as bool? ?? false,
          temperature: (detail['temperature'] ?? 'Ice (Dingin)').toString(),
          quantity: (detail['quantity'] as num?)?.toInt() ?? 1,
          note: (detail['note'] ?? '').toString(),
        ),
      );
    }

    if (_kitchenNote.isEmpty && order.note.isNotEmpty) {
      _kitchenNote = order.note;
    }
    _orderType = order.orderType;
    _tableNumber = order.tableNumber;
    _paymentMethod = order.paymentMethod;

    _orders.removeAt(index);
    return true;
  }
}
