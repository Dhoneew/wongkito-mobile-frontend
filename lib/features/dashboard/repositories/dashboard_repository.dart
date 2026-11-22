import '../../menu/models/menu.dart';

class DashboardRepository {
  final List<Menu> _recommendedMenus = [
    const Menu(
      name: 'Kopi Susu',
      description: 'Kopi susu khas Wong Kito',
      price: 18000,
      note: '',
      category: 'Kopi',
      image: 'assets/images/kopi_susu.png',
    ),
    const Menu(
      name: 'Matcha Latte',
      description: 'Matcha latte',
      price: 20000,
      note: '',
      category: 'Non-Kopi',
      image: 'assets/images/matcha_latte.png',
    ),
  ];

  List<Menu> getRecommendedMenus() {
    return List.unmodifiable(_recommendedMenus);
  }
}
