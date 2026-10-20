
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const Color orange = Color(0xFFF79F1A);
  static const Color bg = Color(0xFFFAF9F9);
  static const Color dark = Color(0xFF1A1C1C);
  static const Color grey = Color(0xFF888888);
  static const Color border = Color(0xFFEAEAEA);

  final TextEditingController _searchController =
      TextEditingController();

  final FocusNode _searchFocus = FocusNode();

  final List<String> _recentSearches = [
    'Ayam Geprek',
    'Milkshake',
    'Cemilan',
    'Matcha',
    'NonCoffee',
  ];

  final List<Map<String, String>> _menus = [
    {
      'name': 'Kopi Susu Wong Kito',
      'price': 'Rp16.000',
      'image': 'assets/images/Onboarding1.png',
      'category': 'Kopi',
    },
    {
      'name': 'Kopi Aren',
      'price': 'Rp18.000',
      'image': 'assets/images/Onboarding1.png',
      'category': 'Kopi',
    },
    {
      'name': 'Kopi Latte',
      'price': 'Rp20.000',
      'image': 'assets/images/Onboarding3.png',
      'category': 'Kopi',
    },
    {
      'name': 'Ayam Geprek',
      'price': 'Rp18.000',
      'image': 'assets/images/Onboarding3.png',
      'category': 'Makanan',
    },
    {
      'name': 'Matcha Latte',
      'price': 'Rp20.000',
      'image': 'assets/images/Onboarding3.png',
      'category': 'Non-Kopi',
    },
    {
      'name': 'Milkshake Cokelat',
      'price': 'Rp17.000',
      'image': 'assets/images/Onboarding1.png',
      'category': 'Non-Kopi',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredMenus {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _menus.where((menu) => menu['category'] == 'Kopi').toList();
    }

    return _menus.where((menu) {
      final name = menu['name']!.toLowerCase();
      final category = menu['category']!.toLowerCase();

      return name.contains(query) || category.contains(query);
    }).toList();
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
            // Header pencarian
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 14, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 19,
                      color: dark,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        autofocus: true,
                        onChanged: (value) => setState(() {}),
                        onSubmitted: _search,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: dark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari menu favoritmu...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 19,
                            color: orange,
                          ),
                          suffixIcon: IconButton(
                            tooltip: 'Hapus pencarian',
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                              _searchFocus.requestFocus();
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: orange,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Konten hasil pencarian
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                children: [
                  const SizedBox(height: 4),
                  const Text(
                    'Hasil Pencarian',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (results.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      alignment: Alignment.center,
                      child: const Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 42,
                            color: grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Menu tidak ditemukan',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: grey,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Coba kata kunci lainnya.',
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

                  const SizedBox(height: 12),

                  const Text(
                    'Pencarian Terakhir',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 7,
                    runSpacing: 8,
                    children: _recentSearches.map((term) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _search(term),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 8,
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
                                size: 13,
                                color: dark,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                term,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
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

  Widget _buildResultCard(Map<String, String> menu) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              menu['image']!,
              width: 58,
              height: 58,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 58,
                  height: 58,
                  color: const Color(0xFFFFE0C2),
                  child: const Icon(
                    Icons.fastfood,
                    color: orange,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu['name']!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  menu['price']!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: dark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}