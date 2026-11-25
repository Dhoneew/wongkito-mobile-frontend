import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/screens/menu/menu_detail_screen.dart';
import 'package:mobile_user/screens/orders/cart_screen.dart';
import 'package:mobile_user/widgets/wkm_skeleton.dart';

void _clearCart() {
  final store = OrderStore.instance;
  for (final item in List<CartItem>.from(store.cart)) {
    store.removeItem(item);
  }
}

Future<void> _pumpDetail(
  WidgetTester tester, {
  bool isLoading = false,
  String? errorMessage,
  VoidCallback? onRetry,
}) async {
  // Detail Menu lebih panjang dari viewport default test (800x600).
  // Perbesar surface agar seluruh konten ListView ikut ter-build.
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: MenuDetailScreen(
        menuName: 'Kopi Susu',
        menuPrice: 'Rp18.000',
        menuImage: 'assets/images/kopi_susu.png',
        isLoading: isLoading,
        errorMessage: errorMessage,
        onRetry: onRetry,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapOption(WidgetTester tester, String label) async {
  await tester.scrollUntilVisible(
    find.text(label),
    300,
    scrollable: find.byType(Scrollable),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

Future<void> _tapQuantity(WidgetTester tester, IconData icon) async {
  await tester.scrollUntilVisible(
    find.byIcon(icon),
    300,
    scrollable: find.byType(Scrollable),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(icon));
  await tester.pumpAndSettle();
}

void main() {
  setUp(_clearCart);

  testWidgets('skeleton detail menggantikan konten tanpa spinner', (tester) async {
    await _pumpDetail(tester, isLoading: true);

    expect(find.byType(WkmMenuDetailSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Tambah ke Keranjang', skipOffstage: false), findsNothing);

    await _pumpDetail(tester);
    expect(find.byType(WkmMenuDetailSkeleton), findsNothing);
    expect(find.text('Tambah ke Keranjang'), findsOneWidget);
  });

  testWidgets('error state menampilkan pesan dan tombol Coba Lagi', (tester) async {
    var retried = false;
    await _pumpDetail(
      tester,
      errorMessage: 'Gagal memuat detail menu.',
      onRetry: () => retried = true,
    );

    expect(find.text('Detail menu belum tersedia'), findsOneWidget);
    expect(find.text('Gagal memuat detail menu.'), findsOneWidget);
    expect(find.text('Coba Lagi'), findsOneWidget);

    await tester.tap(find.text('Coba Lagi'));
    await tester.pumpAndSettle();
    expect(retried, isTrue);
  });

  testWidgets('validasi menampilkan petunjuk inline dekat pilihan yang kosong',
      (tester) async {
    await _pumpDetail(tester);
    await _tapQuantity(tester, Icons.add);

    await tester.ensureVisible(find.text('Tambah ke Keranjang'));
    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih level gula untuk melanjutkan.'), findsOneWidget);
    expect(
      find.textContaining('Silakan pilih level gula'),
      findsOneWidget,
    );

    await tester.tap(find.text('Normal (100%)'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih level gula untuk melanjutkan.'), findsNothing);

    ScaffoldMessenger.of(tester.element(find.byType(MenuDetailScreen)))
        .hideCurrentSnackBar();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Tambah ke Keranjang'));
    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih suhu penyajian untuk melanjutkan.'), findsOneWidget);

    await _tapOption(tester, 'Ice (Dingin)');
    expect(find.text('Pilih suhu penyajian untuk melanjutkan.'), findsNothing);
  });

  testWidgets('quantity 0 menonaktifkan tombol, 1 dan lebih aktif', (tester) async {
    await _pumpDetail(tester);
    final button = find.widgetWithText(ElevatedButton, 'Tambah ke Keranjang');

    expect(tester.widget<ElevatedButton>(button).onPressed, isNull);
    expect(find.text('0', skipOffstage: false), findsWidgets);

    await _tapQuantity(tester, Icons.add);
    expect(tester.widget<ElevatedButton>(button).onPressed, isNotNull);
    expect(find.text('Rp18.000'), findsWidgets);

    await _tapQuantity(tester, Icons.add);
    expect(find.text('2', skipOffstage: false), findsWidgets);
    expect(find.text('Rp36.000'), findsWidgets);
  });

  testWidgets('extra shot mengubah unit price, ringkasan, dan subtotal realtime',
      (tester) async {
    await _pumpDetail(tester);
    await _tapQuantity(tester, Icons.add);

    expect(find.textContaining('Extra Shot'), findsWidgets);
    await _tapOption(tester, 'Extra Shot (+Rp5.000)');

    expect(find.text('Rp23.000'), findsWidgets);
    expect(find.textContaining('Extra Shot'), findsWidgets);

    await _tapOption(tester, 'Tidak');
    await tester.pumpAndSettle();

    expect(find.text('Rp23.000'), findsNothing);
    expect(find.text('Rp18.000'), findsWidgets);
  });

  testWidgets('tambah ke keranjang with customisasi tetap di detail dan snackbar '
      'memiliki aksi Lihat Keranjang', (tester) async {
    final store = OrderStore.instance;
    await _pumpDetail(tester);

    await _tapOption(tester, 'Less Sugar (50%)');
    await _tapOption(tester, 'Extra Shot (+Rp5.000)');
    await _tapOption(tester, 'Ice (Dingin)');
    await _tapQuantity(tester, Icons.add);
    await _tapQuantity(tester, Icons.add);

    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.pumpAndSettle();

    expect(store.cart, hasLength(1));
    expect(store.cart.first.sugarLevel, 'Less Sugar (50%)');
    expect(store.cart.first.extraShot, isTrue);
    expect(store.cart.first.temperature, 'Ice (Dingin)');
    expect(store.cart.first.quantity, 2);
    expect(store.cart.first.subtotal, 46000);

    expect(
      find.textContaining('Kopi Susu berhasil ditambahkan ke keranjang'),
      findsOneWidget,
    );
    expect(find.byType(MenuDetailScreen), findsOneWidget);

    await tester.tap(find.text('Lihat Keranjang'));
    await tester.pumpAndSettle();
    expect(find.byType(CartScreen), findsOneWidget);
  });

  testWidgets('menu sama dengan customisasi berbeda tidak tercampur',
      (tester) async {
    final store = OrderStore.instance;
    await _pumpDetail(tester);

    await _tapOption(tester, 'Normal (100%)');
    await _tapOption(tester, 'Ice (Dingin)');
    await _tapQuantity(tester, Icons.add);
    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.pumpAndSettle();

    await _tapOption(tester, 'Less Sugar (50%)');
    await _tapOption(tester, 'Hot (Panas)');
    await tester.tap(find.text('Tambah ke Keranjang'));
    await tester.pumpAndSettle();

    expect(store.cart, hasLength(2));
    expect(
      store.cart.map((item) => item.sugarLevel).toList(),
      ['Normal (100%)', 'Less Sugar (50%)'],
    );
    expect(store.cart.first.temperature, 'Ice (Dingin)');
    expect(store.cart.last.temperature, 'Hot (Panas)');
  });
}
