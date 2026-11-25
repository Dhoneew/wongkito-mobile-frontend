import 'package:flutter/foundation.dart';

import '../models/menu.dart';
import '../repositories/menu_repository.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuRepository repository;

  MenuViewModel(this.repository);

  int _selectedCategory = 0;
  bool _isError = false;
  bool _isLoading = false;

  int get selectedCategory => _selectedCategory;
  bool get isError => _isError;
  bool get isLoading => _isLoading;

  List<Menu> get menus => repository.getMenus();

  List<String> get categories => repository.getCategories();

  /// Jumlah menu per kategori dipakai chip agar pengguna tahu isi tiap filter.
  int countForCategory(int index) {
    if (index == 0) return menus.length;
    if (index >= categories.length) return 0;
    return menus.where((menu) => menu.category == categories[index]).length;
  }

  List<Menu> get filteredMenus {
    if (_selectedCategory == 0) {
      return menus;
    }

    return menus
        .where((menu) => menu.category == categories[_selectedCategory])
        .toList();
  }

  void selectCategory(int index) {
    _selectedCategory = index;
    notifyListeners();
  }

  Future<void> retryMenu() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    _isLoading = false;
    _isError = false;

    notifyListeners();
  }
}
