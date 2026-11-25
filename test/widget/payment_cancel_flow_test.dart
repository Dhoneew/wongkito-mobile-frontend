import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/screens/orders/payment_screen.dart';

CartItem _item() {
  return CartItem(
    menuName: 'Kopi Susu',
    menuImage: 'assets/images/kopi_susu.png',
    price: 18000,
    sugarLevel: 'Normal (100%)',
    extraShot: false,
    temperature: 'Ice (Dingin)',
    quantity: 1,
  );
}

void main() {
  testWidgets('QRIS memakai total order nyata dan batal mengembalikan item',
      (tester) async {
    final store = OrderStore.instance;
    for (final item in List<CartItem>.from(store.cart)) {
      store.removeItem(item);
    }

    store.setPaymentMethod('QRIS');
    store.addItem(_item());
    final orderId = store.checkout();

    expect(orderId, isNotNull);
    expect(store.cart, isEmpty);

    final order = store.viewModel.getOrderById(orderId!);
    expect(order, isNotNull);
    expect(order!.price, 18000);

    await tester.pumpWidget(
      MaterialApp(
        home: PaymentCodeScreen(
          orderId: orderId,
          totalAmount: order.price,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Kartu rincian ada di dalam ListView, jadi perlu digulir ke viewport.
    await tester.ensureVisible(
      find.textContaining('18.000', skipOffstage: false),
    );
    await tester.pump();

    // Tidak ada fallback dummy 36000; yang tampil adalah total pesanan nyata.
    expect(find.textContaining('18.000'), findsWidgets);
    expect(find.textContaining('36.000'), findsNothing);

    await tester.tap(find.text('Batalkan Pembayaran'));
    await tester.pumpAndSettle();

    expect(find.text('Batalkan Pembayaran?'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Batalkan'),
      ),
    );
    await tester.pumpAndSettle();

    expect(store.cart, hasLength(1));
    expect(store.cart.first.menuName, 'Kopi Susu');
    expect(store.viewModel.getOrderById(orderId), isNull);
  });
}
