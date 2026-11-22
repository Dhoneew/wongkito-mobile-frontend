
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/features/orders/repositories/order_repository.dart';

void main() {
  late OrderRepository repository;

  setUp(() {
    repository = OrderRepository();
  });

  CartItem createItem({int quantity = 1}) {
    return CartItem(
      menuName: 'Kopi Susu Wong Kito',
      menuImage: 'assets/images/kopi.png',
      price: 18000,
      sugarLevel: 'Normal (100%)',
      extraShot: false,
      temperature: 'Ice (Dingin)',
      quantity: quantity,
    );
  }

  group('OrderRepository', () {
    test('menambahkan item ke keranjang', () {
      repository.addItem(createItem());

      expect(repository.cart.length, 1);
    });

    test('menghitung total keranjang', () {
      repository.addItem(createItem(quantity: 2));

      expect(repository.cartTotal, 36000);
      expect(repository.cartQuantity, 2);
    });

    test('mengubah kuantitas item', () {
      final item = createItem();
      repository.addItem(item);
      repository.updateQuantity(item, 3);

      expect(repository.cartQuantity, 3);
      expect(repository.cartTotal, 54000);
    });

    test('menghapus item dari keranjang', () {
      final item = createItem();
      repository.addItem(item);
      repository.removeItem(item);

      expect(repository.cart, isEmpty);
    });

    test('checkout menyimpan pesanan', () {
      repository.addItem(createItem(quantity: 2));
      repository.checkout();

      expect(repository.orders.length, 1);
      expect(repository.orders.first.id, 'WK-101');
      expect(repository.orders.first.price, 36000);
      expect(repository.cart, isEmpty);
    });

    test('checkout tidak membuat pesanan jika keranjang kosong', () {
      repository.checkout();

      expect(repository.orders, isEmpty);
    });
  });
}
