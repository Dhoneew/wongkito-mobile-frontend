import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/screens/menu/menu_screen.dart';

void main() {
  testWidgets('Info Menu jujur sebagai katalog lokal dan aksi muat ulang bekerja',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MenuScreen()));

    expect(find.text('Semua (7)', skipOffstage: false), findsOneWidget);
    expect(find.text('Kopi (3)', skipOffstage: false), findsOneWidget);

    await tester.tap(find.byTooltip('Info Menu'));
    await tester.pumpAndSettle();

    expect(find.text('Katalog Menu Demo'), findsOneWidget);
    expect(find.text('Tersedia di perangkat'), findsOneWidget);
    expect(find.text('Status Koneksi Internet'), findsNothing);

    await tester.tap(find.text('Muat Ulang Menu'));
    await tester.pump();
    // retryMenu() perlu ~1,2-detik; snackbar 2 detik masih terlihat.
    await tester.pump(const Duration(milliseconds: 1300));

    expect(find.text('Katalog menu sudah diperbarui.'), findsOneWidget);
  });
}
