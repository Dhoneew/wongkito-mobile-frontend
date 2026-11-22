import 'package:flutter/foundation.dart';

import '../../menu/models/menu.dart';
import '../repositories/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardViewModel(this.repository);

  String _selectedCategory = 'Semua';

  String get selectedCategory => _selectedCategory;

  List<Menu> get recommendedMenus {
    final menus = repository.getRecommendedMenus();

    if (_selectedCategory == 'Semua') {
      return menus;
    }

    return menus.where((menu) => menu.category == _selectedCategory).toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
