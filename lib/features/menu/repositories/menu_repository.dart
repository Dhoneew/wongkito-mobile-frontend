import '../models/menu.dart';

class MenuRepository {
  final List<Menu> _menus = [
    const Menu(
      name: 'Kopi Susu',
      description: 'Kopi espresso robusta + susu kental manis & gula aren',
      price: 18000,
      note: 'Estimasi saji: ~5 mnt',
      category: 'Kopi',
      image: 'assets/images/kopi_susu.png',
    ),
    const Menu(
      name: 'Matcha Latte',
      description: 'Pure green tea matcha dengan fresh milk lembut',
      price: 20000,
      note: 'Bisa dingin / panas',
      category: 'Non-Kopi',
      image: 'assets/images/matcha_latte.png',
    ),
    const Menu(
      name: 'Pisang Goreng Keju',
      description: 'Pisang kepok goreng renyah dengan taburan keju',
      price: 15000,
      note: 'Camilan hangat',
      category: 'Makanan',
      image: 'assets/images/ayam_geprek.png',
    ),
  ];

  List<Menu> getMenus() {
    return List.unmodifiable(_menus);
  }

  List<String> getCategories() {
    return ['Semua (24)', 'Kopi', 'Non-Kopi', 'Makanan'];
  }
}
