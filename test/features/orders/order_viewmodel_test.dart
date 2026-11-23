
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/features/orders/repositories/order_repository.dart';
import 'package:mobile_user/features/orders/viewmodels/order_viewmodel.dart';

void main() {
  late OrderViewModel viewModel;

  setUp(() {
    final repository = OrderRepository();
    viewModel = OrderViewModel(repository);
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

  group('OrderViewModel', () {
    test('menambahkan item ke keranjang', () {
      viewModel.addItem(createItem());

      expect(viewModel.cart.length, 1);
      expect(viewModel.cartQuantity, 1);
    });

    test('mengubah kuantitas item', () {
      final item = createItem();
      viewModel.addItem(item);

      viewModel.updateQuantity(item, 3);

      expect(viewModel.cartQuantity, 3);
      expect(viewModel.cartTotal, 54000);
    });

    test('menghapus item dari keranjang', () {
      final item = createItem();
      viewModel.addItem(item);

      viewModel.removeItem(item);

      expect(viewModel.cart, isEmpty);
    });

    test('checkout menyimpan pesanan dan mengosongkan keranjang', () {
      viewModel.addItem(createItem(quantity: 2));

      viewModel.checkout();

      expect(viewModel.orders.length, 1);
      expect(viewModel.orders.first.price, 36000);
      expect(viewModel.cart, isEmpty);
    });

    test('memberitahu listener ketika data berubah', () {
      var notified = false;

      viewModel.addListener(() {
        notified = true;
      });

      viewModel.addItem(createItem());

      expect(notified, isTrue);
    });
  });
}
