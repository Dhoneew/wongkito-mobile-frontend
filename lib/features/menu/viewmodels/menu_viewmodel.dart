import 'package:flutter/foundation.dart';

import '../models/menu.dart';
import '../repositories/menu_repository.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuRepository repository;

  MenuViewModel(this.repository);

  int _selectedCategory = 0;
  bool _isError = true;
  bool _isLoading = false;

  int get selectedCategory => _selectedCategory;
  bool get isError => _isError;
  bool get isLoading => _isLoading;

  List<Menu> get menus => repository.getMenus();

  List<String> get categories => repository.getCategories();

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

  void toggleMenuState() {
    _isError = !_isError;
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
