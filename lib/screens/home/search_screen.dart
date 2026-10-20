import 'package:flutter/material.dart';
import '../menu/menu_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const Color orange = Color(0xFFFF5E00);
  static const Color bg = Color(0xFFFAF9F9);
  static const Color dark = Color(0xFF1A1C1C);
  static const Color grey = Color(0xFF888888);
  static const Color border = Color(0xFFE5E5E5);

  final TextEditingController _searchController =
      TextEditingController(text: 'Kopi');
  final FocusNode _searchFocus = FocusNode();

  // Filter States
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

  final List<Map<String, dynamic>> _menus = [
    {
      'name': 'Kopi Susu Wong Kito',
      'price': 'Rp.16.000',
      'priceVal': 16000,
      'image': 'assets/images/kopi_susu.png',
      'category': 'Kopi',
    },
    {
      'name': 'Kopi Aren',
      'price': 'Rp18.000',
      'priceVal': 18000,
      'image': 'assets/images/kopi_aren.png',
      'category': 'Kopi',
    },
    {
      'name': 'Kopi Latte',
      'price': 'Rp20.000',
      'priceVal': 20000,
      'image': 'assets/images/kopi_latte.png',
      'category': 'Kopi',
    },
    {
      'name': 'Ayam Geprek',
      'price': 'Rp18.000',
      'priceVal': 18000,
      'image': 'assets/images/ayam_geprek.png',
      'category': 'Makanan',
    },
    {
      'name': 'Matcha Latte',
      'price': 'Rp20.000',
      'priceVal': 20000,
      'image': 'assets/images/matcha_latte.png',
      'category': 'Non-Kopi',
    },
    {
      'name': 'Milkshake Cokelat',
      'price': 'Rp17.000',
      'priceVal': 17000,
      'image': 'assets/images/Onboarding1.png',
      'category': 'Non-Kopi',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Atur kursor di akhir teks 'Kopi'
    _searchController.selection = TextSelection.collapsed(
      offset: _searchController.text.length,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  bool get _hasActiveFilter {
    return _selectedCategory != 'Semua' ||
        _selectedSort != 'Paling Sesuai' ||
        _selectedPriceRange != 'Semua Harga';
  }

  List<Map<String, dynamic>> get _filteredMenus {
    final query = _searchController.text.trim().toLowerCase();

    var list = _menus.where((menu) {
      final name = menu['name']!.toString().toLowerCase();
      final category = menu['category']!.toString().toLowerCase();

      // Filter berdasarkan teks pencarian
      final matchesQuery = query.isEmpty ||
          name.contains(query) ||
          category.contains(query);

      // Filter berdasarkan kategori
      final matchesCategory = _selectedCategory == 'Semua' ||
          menu['category'] == _selectedCategory;

      // Filter berdasarkan rentang harga
      final price = menu['priceVal'] as int;
      bool matchesPrice = true;
      if (_selectedPriceRange == '< Rp18.000') {
        matchesPrice = price < 18000;
      } else if (_selectedPriceRange == 'Rp18.000 - Rp20.000') {
        matchesPrice = price >= 18000 && price <= 20000;
      } else if (_selectedPriceRange == '> Rp20.000') {
        matchesPrice = price > 20000;
      }

      return matchesQuery && matchesCategory && matchesPrice;
    }).toList();

    // Urutkan (Sorting)
    if (_selectedSort == 'Harga Terendah') {
      list.sort((a, b) => (a['priceVal'] as int).compareTo(b['priceVal'] as int));
    } else if (_selectedSort == 'Harga Tertinggi') {
      list.sort((a, b) => (b['priceVal'] as int).compareTo(a['priceVal'] as int));
    } else if (_selectedSort == 'Nama A-Z') {
      list.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    }

    return list;
  }

  void _search(String value) {
    setState(() {
      _searchController.text = value;
      _searchController.selection = TextSelection.collapsed(
        offset: value.length,
      );

      if (value.trim().isNotEmpty &&
          !_recentSearches.contains(value.trim())) {
        _recentSearches.insert(0, value.trim());
        if (_recentSearches.length > 6) {
          _recentSearches.removeLast();
        }
      }
    });
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
                              onChanged: (value) => setState(() {}),
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
                            setState(() {
                              _selectedCategory = 'Semua';
                              _selectedSort = 'Paling Sesuai';
                              _selectedPriceRange = 'Semua Harga';
                            });
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
                    children: _recentSearches.map((term) {
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
  Widget _buildResultCard(Map<String, dynamic> menu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MenuDetailScreen(
              menuName: menu['name'] as String,
              menuPrice: menu['price'] as String,
              menuImage: menu['image'] as String,
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
                menu['image'] as String,
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
                    menu['name'] as String,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    menu['price'] as String,
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
    String tempCategory = _selectedCategory;
    String tempSort = _selectedSort;
    String tempPrice = _selectedPriceRange;

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
                            setState(() {
                              _selectedCategory = tempCategory;
                              _selectedSort = tempSort;
                              _selectedPriceRange = tempPrice;
                            });
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
