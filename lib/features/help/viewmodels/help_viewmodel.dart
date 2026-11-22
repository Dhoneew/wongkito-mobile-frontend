import 'package:flutter/foundation.dart';

import '../models/help_item.dart';
import '../repositories/help_repository.dart';

class HelpViewModel extends ChangeNotifier {
  final HelpRepository repository;

  HelpViewModel(this.repository);

  List<HelpItem> _helpItems = [];
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  List<HelpItem> get helpItems => _helpItems;

  String get selectedCategory => _selectedCategory;

  String get searchQuery => _searchQuery;

  List<String> get categories => repository.getCategories();

  List<HelpItem> get filteredHelpItems {
    return _helpItems.where((item) {
      final matchesCategory =
          _selectedCategory == 'Semua' || item.category == _selectedCategory;

      final matchesSearch =
          item.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.answer.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void loadHelpItems() {
    _helpItems = repository.getHelpItems();
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
