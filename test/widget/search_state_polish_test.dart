import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/screens/home/search_screen.dart';
import 'package:mobile_user/widgets/wkm_skeleton.dart';

void main() {
  testWidgets('Search skeleton dipakai saat loading dan tanpa spinner',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen(isLoading: true)));
    await tester.pumpAndSettle();

    expect(find.byType(WkmSearchResultSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Hasil Pencarian'), findsNothing);

    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));
    await tester.pumpAndSettle();
    expect(find.byType(WkmSearchResultSkeleton), findsNothing);
    expect(find.text('Hasil Pencarian'), findsOneWidget);
  });

  testWidgets('empty result punya CTA Lihat Semua Menu yang membersihkan query',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SearchScreen()));
    await tester.enterText(find.byType(TextField), 'tidak-ada-menu');
    await tester.pumpAndSettle();

    expect(find.text('Menu tidak ditemukan'), findsOneWidget);
    expect(find.text('Lihat Semua Menu'), findsOneWidget);

    await tester.tap(find.text('Lihat Semua Menu'));
    await tester.pumpAndSettle();

    expect(find.text('Menu tidak ditemukan'), findsNothing);
    expect(find.text('Hasil Pencarian'), findsOneWidget);
    expect(find.text('Rp18.000'), findsWidgets);
    expect(find.text('tidak-ada-menu'), findsNothing);
  });
}
