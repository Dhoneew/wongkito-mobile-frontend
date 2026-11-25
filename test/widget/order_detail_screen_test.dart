import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/screens/orders/order_detail_screen.dart';
import 'package:mobile_user/theme/wkm_style.dart';

void main() {
  testWidgets('detail pesanan menampilkan item, meja, metode, catatan, dan total',
      (tester) async {
    final store = OrderStore.instance;
    store.setOrderType('Dine-in (Makan di Tempat)');
    store.setTableNumber('Meja 07');
    store.setPaymentMethod('E-Wallet Langsung');
    store.setKitchenNote('Tanpa sambal');
    store.addItem(
      CartItem(
        menuName: 'Kopi Susu',
        menuImage: 'assets/images/kopi_susu.png',
        price: 18000,
        sugarLevel: 'Half (50%)',
        extraShot: true,
        temperature: 'Ice (Dingin)',
        quantity: 2,
        note: 'Es sedikit',
      ),
    );

    final orderId = store.checkout()!;

    await tester.pumpWidget(
      MaterialApp(home: OrderDetailScreen(orderId: orderId)),
    );

    expect(find.text('Detail Pesanan'), findsOneWidget);
    expect(find.text('#$orderId'), findsWidgets);
    expect(find.text('Dine-in · Meja 07'), findsOneWidget);
    expect(find.text('Nomor Meja'), findsOneWidget);
    expect(find.text('Meja 07'), findsWidgets);
    expect(find.text('Metode Pembayaran'), findsOneWidget);
    expect(find.text('E-Wallet Langsung'), findsOneWidget);
    expect(find.text('Status Pembayaran'), findsOneWidget);
    expect(find.text('Lunas'), findsOneWidget);
    expect(find.byIcon(wkmStatusIcon('Sedang Diproses')), findsOneWidget);
    expect(find.text('Catatan'), findsOneWidget);
    expect(find.text('Tanpa sambal'), findsOneWidget);
    expect(find.text('2x Kopi Susu'), findsOneWidget);
    expect(find.textContaining('Es sedikit'), findsOneWidget);
    expect(find.textContaining('Extra Shot'), findsOneWidget);
    expect(
      find.text('Total Pesanan', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('Rp46.000', skipOffstage: false), findsWidgets);
  });
}
