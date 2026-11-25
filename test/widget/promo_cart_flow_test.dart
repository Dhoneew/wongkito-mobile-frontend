import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/screens/home/promo_detail_screen.dart';

void _clearCart() {
  final store = OrderStore.instance;
  for (final item in List<CartItem>.from(store.cart)) {
    store.removeItem(item);
  }
}

void main() {
  setUp(_clearCart);

  testWidgets('Ambil Promo hanya masuk keranjang dan tetap di halaman promo',
      (tester) async {
    final store = OrderStore.instance;

    await tester.pumpWidget(const MaterialApp(home: PromoDetailScreen()));
    await tester.ensureVisible(find.text('Ambil Promo'));
    await tester.tap(find.text('Ambil Promo'));
    await tester.pumpAndSettle();

    expect(store.cart, hasLength(1));
    expect(store.cart.first.menuName, 'Paket Hemat Kenyang');
    expect(store.cart.first.price, 25000);
    expect(store.orders, isEmpty);

    // Tidak auto-navigasi ke cart; snackbar memberi aksi eksplisit.
    expect(find.text('Lihat Keranjang'), findsOneWidget);
    expect(find.text('Lanjut Checkout'), findsNothing);
    expect(find.text('Ambil Promo'), findsOneWidget);

    await tester.tap(find.text('Lihat Keranjang'));
    await tester.pumpAndSettle();

    expect(find.text('Lanjut Checkout'), findsOneWidget);
    expect(find.text('Paket Hemat Kenyang'), findsWidgets);
  });
}
