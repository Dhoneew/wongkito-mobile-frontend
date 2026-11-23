import '../../menu/models/menu.dart';

class SearchRepository {
  final List<Menu> _menus = [
    const Menu(
      name: 'Kopi Susu Wong Kito',
      description: 'Kopi susu khas Wong Kito',
      price: 16000,
      note: '',
      category: 'Kopi',
      image: 'assets/images/kopi_susu.png',
    ),
    const Menu(
      name: 'Kopi Aren',
      description: 'Kopi dengan gula aren',
      price: 18000,
      note: '',
      category: 'Kopi',
      image: 'assets/images/kopi_aren.png',
    ),
    const Menu(
      name: 'Kopi Latte',
      description: 'Kopi latte',
      price: 20000,
      note: '',
      category: 'Kopi',
      image: 'assets/images/kopi_latte.png',
    ),
    const Menu(
      name: 'Ayam Geprek',
      description: 'Ayam geprek',
      price: 18000,
      note: '',
      category: 'Makanan',
      image: 'assets/images/ayam_geprek.png',
    ),
    const Menu(
      name: 'Matcha Latte',
      description: 'Matcha latte',
      price: 20000,
      note: '',
      category: 'Non-Kopi',
      image: 'assets/images/matcha_latte.png',
    ),
    const Menu(
      name: 'Milkshake Cokelat',
      description: 'Milkshake cokelat',
      price: 17000,
      note: '',
      category: 'Non-Kopi',
      image: 'assets/images/Onboarding1.png',
    ),
  ];

  List<Menu> getMenus() => List.unmodifiable(_menus);
}
