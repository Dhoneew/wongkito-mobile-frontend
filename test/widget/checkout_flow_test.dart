import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/screens/orders/checkout_screen.dart';

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
  final store = OrderStore.instance;

  testWidgets('checkout kosong menampilkan empty state dan tidak membuat pesanan',
      (tester) async {
    expect(store.cart, isEmpty);

    await tester.pumpWidget(const MaterialApp(home: CheckoutScreen()));

    expect(find.text('Belum ada yang di-checkout'), findsOneWidget);
    expect(find.textContaining('Buat Pesanan'), findsNothing);
  });

  testWidgets('checkout cash menyimpan catatan dan membuka halaman sukses',
      (tester) async {
    store.setPaymentMethod('Bayar Kasir (Cash / Tunai)');
    store.setKitchenNote('Tanpa sambal');
    store.addItem(_item());

    final ordersBefore = store.orders.length;

    await tester.pumpWidget(const MaterialApp(home: CheckoutScreen()));

    final submit = find.textContaining('Buat Pesanan');
    expect(submit, findsOneWidget);

    // Ketuk dua kali untuk memastikan _isSubmitting mencegah checkout duplikat.
    await tester.tap(submit);
    await tester.tap(submit);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.text('Buat Pesanan?'), findsOneWidget);
    expect(find.textContaining('Tanpa sambal'), findsNothing);

    await tester.tap(find.text('Konfirmasi'));
    await tester.pumpAndSettle();

    expect(store.orders.length, ordersBefore + 1);
    expect(store.cart, isEmpty);
    expect(find.text('Pesanan Berhasil Dibuat!'), findsOneWidget);
    expect(
      find.text('Bayar Kasir (Cash / Tunai)'),
      findsOneWidget,
    );
    expect(find.textContaining('Kode Pembayaran'), findsNothing);
  });

  testWidgets('checkout QRIS membuka kode pembayaran', (tester) async {
    store.setPaymentMethod('QRIS');
    store.addItem(_item());

    await tester.pumpWidget(const MaterialApp(home: CheckoutScreen()));

    await tester.tap(find.textContaining('Buat Pesanan'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Kode Pembayaran'), findsOneWidget);
  });
}
