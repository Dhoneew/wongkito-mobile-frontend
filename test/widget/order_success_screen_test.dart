import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/screens/orders/order_success_screen.dart';

void main() {
  testWidgets('halaman sukses menampilkan ringkasan pesanan yang baru dibuat',
      (tester) async {
    final store = OrderStore.instance;
    store.setPaymentMethod('Bayar Kasir (Cash / Tunai)');
    store.addItem(
      CartItem(
        menuName: 'Kopi Susu',
        menuImage: 'assets/images/kopi_susu.png',
        price: 18000,
        sugarLevel: 'Normal (100%)',
        extraShot: false,
        temperature: 'Ice (Dingin)',
        quantity: 1,
      ),
    );

    final orderId = store.checkout()!;

    await tester.pumpWidget(
      MaterialApp(home: OrderSuccessScreen(orderId: orderId)),
    );

    expect(find.text('Pesanan Berhasil Dibuat!'), findsOneWidget);
    expect(
      find.text('Pesananmu sudah kami terima. Bayar di kasir saat mengambil pesanan.'),
      findsOneWidget,
    );
    expect(find.textContaining('#$orderId'), findsWidgets);
    expect(find.text('1x Kopi Susu'), findsOneWidget);
    expect(find.text('Rp18.000'), findsWidgets);
    expect(find.text('Bayar Kasir (Cash / Tunai)'), findsOneWidget);
    expect(find.text('Lihat Status Pesanan'), findsOneWidget);
    expect(find.text('Kembali ke Home'), findsOneWidget);
  });

  testWidgets('sukses QRIS memakai judul pembayaran setelah dikonfirmasi',
      (tester) async {
    final store = OrderStore.instance;
    store.setPaymentMethod('QRIS');
    store.addItem(
      CartItem(
        menuName: 'Matcha Latte',
        menuImage: 'assets/images/matcha_latte.png',
        price: 20000,
        sugarLevel: 'Normal (100%)',
        extraShot: false,
        temperature: 'Ice (Dingin)',
        quantity: 1,
      ),
    );

    final orderId = store.checkout()!;
    expect(store.markOrderPaid(orderId), isTrue);

    await tester.pumpWidget(
      MaterialApp(home: OrderSuccessScreen(orderId: orderId)),
    );

    expect(find.text('Pembayaran Berhasil'), findsOneWidget);
    expect(
      find.text('Pembayaran simulasi sudah dikonfirmasi. Pesananmu siap disiapkan.'),
      findsOneWidget,
    );
    expect(find.text('QRIS (Simulasi)'), findsOneWidget);
  });
}
