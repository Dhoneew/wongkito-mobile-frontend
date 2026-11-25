import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/features/search/repositories/search_repository.dart';
import 'package:mobile_user/features/search/viewmodels/search_viewmodel.dart';

void main() {
  group('Filter pencarian WKM', () {
    test('default: Relevan dan belum ada filter aktif', () {
      final vm = SearchViewModel(SearchRepository());

      expect(vm.selectedCategory, SearchViewModel.defaultCategory);
      expect(vm.selectedSort, 'Relevan');
      expect(vm.selectedPriceRange, SearchViewModel.defaultPriceRange);
      expect(vm.hasActiveFilter, isFalse);
    });

    test('kategori + rentang harga + sorting dapat dikombinasikan', () {
      final vm = SearchViewModel(SearchRepository());
      vm.applyFilters(
        category: 'Non-Kopi',
        sort: 'Harga Termurah',
        priceRange: '< Rp18.000',
      );

      final names = vm.filteredMenus.map((menu) => menu.name).toList();
      expect(names, ['Milkshake Cokelat']);
      expect(vm.hasActiveFilter, isTrue);
    });

    test('Harga Termurah dan Harga Termahal benar-benar mengurutkan harga', () {
      final vm = SearchViewModel(SearchRepository());

      vm.applyFilters(
        category: 'Kopi',
        sort: 'Harga Termurah',
        priceRange: SearchViewModel.defaultPriceRange,
      );
      expect(
        vm.filteredMenus.map((menu) => menu.price).toList(),
        [18000, 18000, 20000],
      );

      vm.applyFilters(
        category: 'Kopi',
        sort: 'Harga Termahal',
        priceRange: SearchViewModel.defaultPriceRange,
      );
      expect(
        vm.filteredMenus.map((menu) => menu.price).toList(),
        [20000, 18000, 18000],
      );
    });

    test('reset mengembalikan filter default tanpa menghapus query', () {
      final vm = SearchViewModel(SearchRepository());
      vm.updateQuery('Matcha');
      vm.applyFilters(
        category: 'Makanan',
        sort: 'Harga Termahal',
        priceRange: '> Rp20.000',
      );
      expect(vm.filteredMenus, isEmpty);

      vm.resetFilters();

      expect(vm.query, 'Matcha');
      expect(vm.hasActiveFilter, isFalse);
      expect(vm.filteredMenus.map((menu) => menu.name).toList(), [
        'Matcha Latte',
      ]);
    });
  });
}
