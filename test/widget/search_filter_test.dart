import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/screens/home/search_screen.dart';

Future<void> _openFilter(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Filter pencarian'));
  await tester.pumpAndSettle();
  expect(find.text('Filter & Urutkan'), findsOneWidget);
}

Future<void> _apply(WidgetTester tester) async {
  await tester.tap(find.text('Terapkan Filter'));
  await tester.pumpAndSettle();
  expect(find.text('Filter & Urutkan'), findsNothing);
}

void main() {
  testWidgets('ikon filter membuka bottom sheet di halaman Search yang sama',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));

    await _openFilter(tester);

    // Tidak ada navigasi ke halaman filter baru.
    expect(find.byType(SearchScreen), findsOneWidget);
    expect(find.text('Paling Sesuai'), findsNothing);
    expect(find.text('Harga Termurah'), findsOneWidget);
    expect(find.text('Harga Termahal'), findsOneWidget);
    expect(find.text('Relevan'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Filter & Urutkan'), findsNothing);
    expect(find.byType(SearchScreen), findsOneWidget);
  });

  testWidgets('filter dikombinasikan, query dipertahankan, reset ke default',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));
    final field = find.byType(TextField);

    await tester.enterText(field, 'Matcha');
    await tester.pumpAndSettle();
    expect(field, findsOneWidget);

    await _openFilter(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Makanan'));
    await tester.tap(find.widgetWithText(ChoiceChip, '< Rp18.000'));
    await _apply(tester);

    // Query "Matcha" tetap ada, tetapi kategori Makanan + harga <18k
    // menghasilkan tidak ada menu (filter benar-benar dikombinasikan).
    expect(field, findsOneWidget);
    expect(find.text('Matcha'), findsWidgets);
    expect(find.text('Menu tidak ditemukan'), findsOneWidget);
    expect(find.text('0 menu'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byTooltip('Filter pencarian'),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );

    await _openFilter(tester);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Reset Filter'));
    await _apply(tester);

    expect(find.text('Menu tidak ditemukan'), findsNothing);
    expect(find.text('Rp20.000'), findsOneWidget);
    expect(find.text('Matcha'), findsWidgets);
  });

  testWidgets('Terapkan langsung mengurutkan hasil di halaman yang sama',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    await _openFilter(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Kopi'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Harga Termahal'));
    await _apply(tester);

    final prices = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data ?? '')
        .where((text) => text.startsWith('Rp'))
        .toList();

    expect(prices, ['Rp20.000', 'Rp18.000', 'Rp18.000']);
    expect(find.byType(SearchScreen), findsOneWidget);
  });
}
