import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/screens/orders/payment_screen.dart';

void main() {
  testWidgets('konfirmasi QRIS gagal menampilkan error inline dan tidak keluar',
      (tester) async {
    // ID tidak ditemukan dipakai untuk memaksa markOrderPaid() gagal tanpa
    // menambah failure buatan ke repository lokal.
    await tester.pumpWidget(
      const MaterialApp(
        home: PaymentCodeScreen(orderId: 'WK-TIDAK-ADA', totalAmount: 18000),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('SAYA SUDAH BAYAR'));
    await tester.pump();
    await tester.tap(find.text('SAYA SUDAH BAYAR'));

    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    expect(find.byType(PaymentCodeScreen), findsOneWidget);
    expect(find.text('Pembayaran belum berhasil'), findsOneWidget);
    expect(
      find.textContaining('Konfirmasi belum berhasil.'),
      findsOneWidget,
    );
    expect(find.text('Coba Lagi'), findsOneWidget);
    expect(find.text('Pilih Metode Lain'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });
}
