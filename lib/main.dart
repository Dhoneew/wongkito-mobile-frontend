
import 'package:flutter/material.dart';

import 'theme/wkm_style.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/menu/menu_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'widgets/bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WKM',
      theme: ThemeData(
        scaffoldBackgroundColor: WkmColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: WkmColors.orange,
          surface: WkmColors.background,
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void _selectTab(int index) {
    if (selectedIndex == index) return;
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardScreen(
        onOpenMenu: () => _selectTab(1),
        onNavigateTab: _selectTab,
      ),
      const MenuScreen(showBackButton: false),
      const OrdersScreen(),
      ProfileScreen(onNavigateTab: _selectTab),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: WkmBottomNav(
        selectedIndex: selectedIndex,
        onTap: _selectTab,
      ),
    );
  }
}
