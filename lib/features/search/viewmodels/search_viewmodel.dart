import 'package:flutter/foundation.dart';

import '../../menu/models/menu.dart';
import '../repositories/search_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final SearchRepository repository;

  SearchViewModel(this.repository);

  /// Label filter dipusatkan di sini agar chip di UI dan logika di ViewModel
  /// tidak bisa berbeda (misalnya chip "Harga Termurah" tapi kode masih
  /// mengecek "Harga Terendah").
  static const String defaultCategory = 'Semua';
  static const String defaultSort = 'Relevan';
  static const String defaultPriceRange = 'Semua Harga';

  static const List<String> categories = [
    defaultCategory,
    'Kopi',
    'Non-Kopi',
    'Makanan',
  ];
  static const List<String> sortOptions = [
    defaultSort,
    'Harga Termurah',
    'Harga Termahal',
  ];
  static const List<String> priceRanges = [
    defaultPriceRange,
    '< Rp18.000',
    'Rp18.000 - Rp20.000',
    '> Rp20.000',
  ];

  String _query = 'Kopi';
  String _selectedCategory = defaultCategory;
  String _selectedSort = defaultSort;
  String _selectedPriceRange = defaultPriceRange;

  final List<String> _recentSearches = [
    'Kopi Susu',
    'Matcha Latte',
    'Pisang Goreng Keju',
    'Kopi',
    'Non-Kopi',
  ];

  String get query => _query;
  String get selectedCategory => _selectedCategory;
  String get selectedSort => _selectedSort;
  String get selectedPriceRange => _selectedPriceRange;

  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  int get activeFilterCount {
    var count = 0;
    if (_selectedCategory != defaultCategory) count++;
    if (_selectedSort != defaultSort) count++;
    if (_selectedPriceRange != defaultPriceRange) count++;
    return count;
  }

  bool get hasActiveFilter => activeFilterCount > 0;

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

    if (_selectedSort == 'Harga Termurah') {
      menus.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Harga Termahal') {
      menus.sort((a, b) => b.price.compareTo(a.price));
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

  /// Reset hanya menyentuh filter; query yang sedang diketik sengaja tidak
  /// diubah agar hasil pencarian tetap kontekstual.
  void resetFilters() {
    _selectedCategory = defaultCategory;
    _selectedSort = defaultSort;
    _selectedPriceRange = defaultPriceRange;
    notifyListeners();
  }
}
