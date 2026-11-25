import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/widgets/wkm_skeleton.dart';

void main() {
  testWidgets('skeleton Menu, Search, Dashboard, dan Detail memakai shimmer '
      'bukan spinner', (tester) async {
    final skeletons = <Widget>[
      const WkmMenuListSkeleton(),
      const WkmSearchResultSkeleton(),
      const WkmDashboardRecommendationSkeleton(),
      const WkmBannerSkeleton(),
      const WkmMenuDetailSkeleton(),
    ];

    for (final skeleton in skeletons) {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: skeleton)));
      await tester.pumpAndSettle();

      expect(find.byType(WkmShimmer), findsOneWidget);
      expect(find.byType(WkmSkeletonBox), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    }
  });
}
