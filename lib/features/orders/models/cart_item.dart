
class CartItem {
  final String menuName;
  final String menuImage;
  final int price;
  final String sugarLevel;
  final bool extraShot;
  final String temperature;

  int quantity;
  String note;

  CartItem({
    required this.menuName,
    required this.menuImage,
    required this.price,
    required this.sugarLevel,
    required this.extraShot,
    required this.temperature,
    required this.quantity,
    this.note = '',
  });

  int get subtotal => quantity * (price + (extraShot ? 5000 : 0));
}
