import 'package:flutter/material.dart';

import '../../features/menu/models/menu.dart';
import '../../features/search/repositories/search_repository.dart';
import '../../features/search/viewmodels/search_viewmodel.dart';
import '../menu/menu_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const Color orange = Color(0xFFF57C00);
  static const Color bg = Color(0xFFFAF9F9);
  static const Color dark = Color(0xFF1A1C1C);
  static const Color grey = Color(0xFF888888);
  static const Color border = Color(0xFFE5E5E5);

  final TextEditingController _searchController =
      TextEditingController(text: 'Kopi');
  final FocusNode _searchFocus = FocusNode();

  late final SearchViewModel viewModel;



  @override
  void initState() {
    super.initState();
    viewModel = SearchViewModel(SearchRepository());
    viewModel.addListener(_onViewModelChanged);
    // Atur kursor di akhir teks 'Kopi'
    _searchController.selection = TextSelection.collapsed(
      offset: _searchController.text.length,
    );
  }
  void _onViewModelChanged() {
  if (mounted) {
    setState(() {});
  }
}

  String rupiah(int value) {
  final formatted = value.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return 'Rp$formatted';
}

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  bool get _hasActiveFilter => viewModel.hasActiveFilter;

List<Menu> get _filteredMenus => viewModel.filteredMenus;

void _search(String value) {
  _searchController.text = value;
  _searchController.selection = TextSelection.collapsed(
    offset: value.length,
  );

  viewModel.search(value);
}

  @override
  Widget build(BuildContext context) {
    final results = _filteredMenus;

    return Scaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER PENCARIAN (SESUAI GAMBAR)
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 14, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: dark,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocus,
                              onChanged: (value) => viewModel.updateQuery(value),
                              onSubmitted: _search,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: dark,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: grey,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          // Tombol Filter
                          GestureDetector(
                            onTap: _showFilterModal,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: orange,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Icon(
                                    Icons.tune,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                                if (_hasActiveFilter)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // KONTEN HASIL & PENCARIAN TERAKHIR
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hasil Pencarian',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: dark,
                        ),
                      ),
                      if (_hasActiveFilter)
                        GestureDetector(
                          onTap: () {
                            viewModel.resetFilters();
                          },
                          child: const Text(
                            'Reset Filter',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (results.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      alignment: Alignment.center,
                      child: const Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 44,
                            color: grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Menu tidak ditemukan',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: dark,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Coba kata kunci atau ubah filter pencarian.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...results.map((menu) => _buildResultCard(menu)),

                  const SizedBox(height: 14),

                  const Text(
                    'Pencarian Terakhir',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: viewModel.recentSearches.map((term) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _search(term),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEAEA),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.search,
                                size: 14,
                                color: dark,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                term,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // KARTU HASIL PENCARIAN (SESUAI GAMBAR)
  Widget _buildResultCard(Menu menu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MenuDetailScreen(
              menuName: menu.name,
              menuPrice: rupiah(menu.price),
              menuImage: menu.image,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                menu.image,
                width: 62,
                height: 62,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 62,
                    height: 62,
                    color: const Color(0xFFFFE0C2),
                    child: const Icon(Icons.coffee, color: orange),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    rupiah(menu.price),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const Color secondaryTextColor = Color(0xFF666666);

  // MODAL FILTER PENCARIAN
  void _showFilterModal() {
    String tempCategory = viewModel.selectedCategory;
    String tempSort = viewModel.selectedSort;
    String tempPrice = viewModel.selectedPriceRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Header Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter & Urutkan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: dark,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: dark),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(height: 12),

                  // 1. Kategori
                  const SizedBox(height: 6),
                  const Text(
                    'Kategori',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Semua', 'Kopi', 'Non-Kopi', 'Makanan'].map((cat) {
                      final isSelected = tempCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: orange,
                        backgroundColor: const Color(0xFFF0F0F0),
                        labelStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : dark,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide.none,
                        ),
                        onSelected: (val) {
                          setModalState(() => tempCategory = cat);
                        },
                      );
                    }).toList(),
                  ),

                  // 2. Urutkan (Sorting)
                  const SizedBox(height: 14),
                  const Text(
                    'Urutkan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Paling Sesuai',
                      'Harga Terendah',
                      'Harga Tertinggi',
                      'Nama A-Z',
                    ].map((sort) {
                      final isSelected = tempSort == sort;
                      return ChoiceChip(
                        label: Text(sort),
                        selected: isSelected,
                        selectedColor: orange,
                        backgroundColor: const Color(0xFFF0F0F0),
                        labelStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : dark,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide.none,
                        ),
                        onSelected: (val) {
                          setModalState(() => tempSort = sort);
                        },
                      );
                    }).toList(),
                  ),

                  // 3. Rentang Harga
                  const SizedBox(height: 14),
                  const Text(
                    'Rentang Harga',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Semua Harga',
                      '< Rp18.000',
                      'Rp18.000 - Rp20.000',
                      '> Rp20.000',
                    ].map((pr) {
                      final isSelected = tempPrice == pr;
                      return ChoiceChip(
                        label: Text(pr),
                        selected: isSelected,
                        selectedColor: orange,
                        backgroundColor: const Color(0xFFF0F0F0),
                        labelStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : dark,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide.none,
                        ),
                        onSelected: (val) {
                          setModalState(() => tempPrice = pr);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 22),

                  // Tombol Aksi
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempCategory = 'Semua';
                              tempSort = 'Paling Sesuai';
                              tempPrice = 'Semua Harga';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCCCCCC)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: dark,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.applyFilters(
                              category: tempCategory,
                              sort: tempSort,
                              priceRange: tempPrice,
                            );
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orange,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Terapkan Filter',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
