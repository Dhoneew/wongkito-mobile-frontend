import '../../menu/models/menu.dart';
import '../../menu/repositories/menu_repository.dart';

class SearchRepository {
  /// Pencarian memakai katalog yang sama dengan Menu agar nama, harga,
  /// deskripsi, dan gambar tidak berbeda antar halaman.
  final MenuRepository _menuRepository = MenuRepository();

  List<Menu> getMenus() => _menuRepository.getMenus();
}
