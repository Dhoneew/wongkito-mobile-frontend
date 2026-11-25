class Order {
  final String id;
  final String items;
  final int price;
  final String date;
  final String status;
  final String orderType;
  final String tableNumber;
  final String paymentMethod;
  final String note;
  final String paymentStatus;
  final List<Map<String, dynamic>> details;

  const Order({
    required this.id,
    required this.items,
    required this.price,
    required this.date,
    required this.status,
    required this.orderType,
    required this.tableNumber,
    required this.paymentMethod,
    required this.note,
    required this.details,
    this.paymentStatus = 'Lunas',
  });
}
