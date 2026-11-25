import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/screens/menu/menu_detail_screen.dart';
import 'package:mobile_user/widgets/cart_icon.dart';

void clearCart() {
  final store = OrderStore.instance;
  for (final item in List<CartItem>.from(store.cart)) {
    store.removeItem(item);
  }
}

void main() {
  setUp(clearCart);

  testWidgets('Tambah ke Keranjang hanya menyimpan item dan tetap di detail',
      (tester) async {
    final store = OrderStore.instance;
    expect(store.cart, isEmpty);

    await tester.pumpWidget(
      const MaterialApp(
        home: MenuDetailScreen(
          menuName: 'Kopi Susu',
          menuPrice: 'Rp18.000',
          menuImage: 'assets/images/kopi_susu.png',
        ),
      ),
    );

    await tester.tap(find.text('Normal (100%)'));

    await tester.scrollUntilVisible(
      find.text('Ice (Dingin)'),
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.pump();
    await tester.tap(find.text('Ice (Dingin)'));

    await tester.scrollUntilVisible(
      find.byIcon(Icons.add),
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.pump();

    expect(store.cart, hasLength(1));
    expect(store.cart.first.menuName, 'Kopi Susu');
    expect(store.cart.first.quantity, 1);
    expect(store.cart.first.sugarLevel, 'Normal (100%)');
    expect(store.cart.first.temperature, 'Ice (Dingin)');
    expect(store.cart.first.subtotal, 18000);

    expect(
      find.textContaining('Kopi Susu berhasil ditambahkan ke keranjang'),
      findsOneWidget,
    );
    // Tidak auto-navigasi: user bisa kembali memilih menu lain.
    expect(
      find.text('Tambah ke Keranjang', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.textContaining('Buat Pesanan'), findsNothing);
    expect(store.orders, isEmpty);
  });

  testWidgets('badge keranjang menampilkan jumlah quantity', (tester) async {
    final store = OrderStore.instance;
    store.addItem(
      CartItem(
        menuName: 'Kopi Susu',
        menuImage: 'assets/images/kopi_susu.png',
        price: 18000,
        sugarLevel: 'Normal (100%)',
        extraShot: false,
        temperature: 'Ice (Dingin)',
        quantity: 2,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WkmCartIcon(onPressed: () {}),
        ),
      ),
    );

    expect(find.text('2', skipOffstage: false), findsOneWidget);
  });
}
