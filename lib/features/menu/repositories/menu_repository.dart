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
    const Menu(
      name: 'Kopi Aren',
      description: 'Kopi espresso dengan gula aren khas warkop',
      price: 18000,
      note: 'Manis alami',
      category: 'Kopi',
      image: 'assets/images/kopi_aren.png',
    ),
    const Menu(
      name: 'Kopi Latte',
      description: 'Espresso lembut dengan busa susu',
      price: 20000,
      note: 'Bisa dingin / panas',
      category: 'Kopi',
      image: 'assets/images/kopi_latte.png',
    ),
    const Menu(
      name: 'Ayam Geprek Sambal Matah',
      description: 'Ayam geprek renyah dengan sambal matah warkop',
      price: 25000,
      note: 'Sambal terpisah',
      category: 'Makanan',
      image: 'assets/images/ayam_geprek.png',
    ),
    const Menu(
      name: 'Milkshake Cokelat',
      description: 'Minuman susu cokelat creamy',
      price: 17000,
      note: 'Disajikan dingin',
      category: 'Non-Kopi',
      image: 'assets/images/matcha_latte.png',
    ),
  ];

  List<Menu> getMenus() {
    return List.unmodifiable(_menus);
  }

  List<String> getCategories() {
    return ['Semua', 'Kopi', 'Non-Kopi', 'Makanan'];
  }
}
