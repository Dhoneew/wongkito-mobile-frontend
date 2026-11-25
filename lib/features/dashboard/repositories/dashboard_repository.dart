import '../../menu/models/menu.dart';
import '../../menu/repositories/menu_repository.dart';

class DashboardRepository {
  /// Dashboard memakai sumber katalog yang sama dengan halaman Menu supaya
  /// nama, harga, deskripsi, dan kategori tidak berbeda antar   halaman.
  final MenuRepository _menuRepository = MenuRepository();

  List<Menu> getRecommendedMenus() {
    // Tiga kartu pertama cukup untuk baris rekomendasi di dashboard.
    return _menuRepository.getMenus().take(3).toList();
  }
}
