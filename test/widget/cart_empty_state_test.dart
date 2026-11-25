import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/main.dart';
import 'package:mobile_user/screens/orders/cart_screen.dart';

void main() {
  testWidgets('cart kosong menampilkan CTA Mulai Belanja ke tab Menu',
      (tester) async {
    final store = OrderStore.instance;
    for (final item in List<CartItem>.from(store.cart)) {
      store.removeItem(item);
    }

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    expect(find.text('Keranjangmu masih kosong'), findsOneWidget);
    expect(find.text('Mulai Belanja'), findsOneWidget);

    await tester.tap(find.text('Mulai Belanja'));
    await tester.pumpAndSettle();

    expect(find.byType(MainNavigation), findsOneWidget);
    expect(find.byType(CartScreen), findsNothing);
  });
}
