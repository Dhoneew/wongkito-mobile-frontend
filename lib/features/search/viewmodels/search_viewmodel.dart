import 'package:flutter/foundation.dart';

import '../../menu/models/menu.dart';
import '../repositories/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository repository;

  SearchViewModel(this.repository);

  String _query = 'Kopi';
  String _selectedCategory = 'Semua';
  String _selectedSort = 'Paling Sesuai';
  String _selectedPriceRange = 'Semua Harga';

  final List<String> _recentSearches = [
    'Ayam Geprek',
    'Milkshake',
    'Cemilan',
    'Matcha',
    'NonCoffe',
  ];

  String get query => _query;
  String get selectedCategory => _selectedCategory;
  String get selectedSort => _selectedSort;
  String get selectedPriceRange => _selectedPriceRange;

  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  bool get hasActiveFilter {
    return _selectedCategory != 'Semua' ||
        _selectedSort != 'Paling Sesuai' ||
        _selectedPriceRange != 'Semua Harga';
  }

  List<Menu> get filteredMenus {
    final query = _query.trim().toLowerCase();

    var menus = repository.getMenus().where((menu) {
      final matchesQuery =
          query.isEmpty ||
          menu.name.toLowerCase().contains(query) ||
          menu.category.toLowerCase().contains(query);

      final matchesCategory =
          _selectedCategory == 'Semua' || menu.category == _selectedCategory;

      bool matchesPrice = true;

      if (_selectedPriceRange == '< Rp18.000') {
        matchesPrice = menu.price < 18000;
      } else if (_selectedPriceRange == 'Rp18.000 - Rp20.000') {
        matchesPrice = menu.price >= 18000 && menu.price <= 20000;
      } else if (_selectedPriceRange == '> Rp20.000') {
        matchesPrice = menu.price > 20000;
      }

      return matchesQuery && matchesCategory && matchesPrice;
    }).toList();

    if (_selectedSort == 'Harga Terendah') {
      menus.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Harga Tertinggi') {
      menus.sort((a, b) => b.price.compareTo(a.price));
    } else if (_selectedSort == 'Nama A-Z') {
      menus.sort((a, b) => a.name.compareTo(b.name));
    }

    return menus;
  }

  void updateQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void search(String value) {
    _query = value;
    _addRecentSearch(value);
    notifyListeners();
  }

  void selectRecentSearch(String value) {
    search(value);
  }

  void _addRecentSearch(String value) {
    final term = value.trim();

    if (term.isEmpty) return;

    _recentSearches.remove(term);
    _recentSearches.insert(0, term);

    if (_recentSearches.length > 6) {
      _recentSearches.removeLast();
    }
  }

  void setCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void setSort(String value) {
    _selectedSort = value;
    notifyListeners();
  }

  void setPriceRange(String value) {
    _selectedPriceRange = value;
    notifyListeners();
  }

  void applyFilters({
    required String category,
    required String sort,
    required String priceRange,
  }) {
    _selectedCategory = category;
    _selectedSort = sort;
    _selectedPriceRange = priceRange;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = 'Semua';
    _selectedSort = 'Paling Sesuai';
    _selectedPriceRange = 'Semua Harga';
    notifyListeners();
  }
}
