import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/screens/orders/cart_screen.dart';

CartItem _item(String name, int price, int quantity) {
  return CartItem(
    menuName: name,
    menuImage: 'assets/images/kopi_susu.png',
    price: price,
    sugarLevel: 'Normal (100%)',
    extraShot: false,
    temperature: 'Ice (Dingin)',
    quantity: quantity,
  );
}

void main() {
  testWidgets('Cart mengatur qty/hapus/total dan checkout hanya dari Cart',
      (tester) async {
    final store = OrderStore.instance;
    final first = _item('Kopi Susu', 18000, 2);
    final second = _item('Matcha Latte', 15000, 1);
    store.addItem(first);
    store.addItem(second);

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    expect(find.text('Lanjut Checkout'), findsOneWidget);
    expect(store.cartTotal, 51000);

    await tester.tap(find.byIcon(Icons.add).at(0));
    await tester.pump();

    expect(first.quantity, 3);
    expect(store.cartTotal, 69000);

    // Mengurangi item yang jumlahnya 1 memakai konfirmasi hapus yang sama.
    await tester.tap(find.byIcon(Icons.remove).at(1));
    await tester.pumpAndSettle();

    expect(find.text('Hapus Item?'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Hapus'),
      ),
    );
    await tester.pumpAndSettle();

    expect(store.cart, hasLength(1));
    expect(store.cart.first.menuName, 'Kopi Susu');
    expect(store.cartTotal, 54000);

    expect(store.orders, isEmpty);

    // Snackbar hapus sengaja bertahan lebih lama karena ada aksi Urungkan.
    // Tutup secara eksplisit supaya tidak menutup CTA di bawahnya.
    final messenger = ScaffoldMessenger.of(tester.element(find.byType(CartScreen)));
    messenger.hideCurrentSnackBar();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lanjut Checkout'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Buat Pesanan'), findsOneWidget);
    expect(store.orders, isEmpty);
  });

  testWidgets('Urungkan mengembalikan item yang baru dihapus', (tester) async {
    final store = OrderStore.instance;
    for (final item in List<CartItem>.from(store.cart)) {
      store.removeItem(item);
    }

    store.addItem(_item('Kopi Aren', 18000, 1));
    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Hapus'),
      ),
    );
    await tester.pumpAndSettle();

    expect(store.cart, isEmpty);
    expect(find.text('Urungkan'), findsOneWidget);

    await tester.tap(find.text('Urungkan'));
    await tester.pumpAndSettle();

    expect(store.cart, hasLength(1));
    expect(store.cart.first.menuName, 'Kopi Aren');
  });
}
