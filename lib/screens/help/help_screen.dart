import 'package:flutter/material.dart';

import '../../features/help/repositories/help_repository.dart';
import '../../features/help/viewmodels/help_viewmodel.dart';
import '../../theme/wkm_style.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late final HelpViewModel viewModel;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = HelpViewModel(HelpRepository());
    viewModel.loadHelpItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  void _resetFilter() {
    _searchController.clear();
    viewModel.updateSearchQuery('');
    viewModel.selectCategory('Semua');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WkmColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: WkmColors.background,
        foregroundColor: WkmColors.dark,
        elevation: 0,
        leading: wkmBackButton(() => Navigator.pop(context)),
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          final items = viewModel.filteredHelpItems;

          return ListView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            children: [
              const Text(
                'Ada yang bisa kami bantu?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: WkmColors.dark,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _searchController,
                onChanged: viewModel.updateSearchQuery,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: WkmColors.dark,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari pertanyaan...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: WkmColors.muted,
                  ),
                  prefixIcon: const Icon(Icons.search, color: WkmColors.orange),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Hapus pencarian',
                          icon: const Icon(Icons.close, color: WkmColors.muted),
                          onPressed: _resetFilter,
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: WkmColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: WkmColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: WkmColors.orange),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: viewModel.categories.map((category) {
                    final selected = viewModel.selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) {
                          viewModel.selectCategory(category);
                        },
                        selectedColor: WkmColors.orange,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: selected ? Colors.white : WkmColors.dark,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Pertanyaan Umum',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: WkmColors.dark,
                ),
              ),

              const SizedBox(height: 10),

              if (items.isEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(24),
                  decoration: wkmCardDecoration(radius: 12),
                  child: Column(
                    children: [
                      const Text(
                        'Pertanyaan tidak ditemukan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: WkmColors.muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _resetFilter,
                        child: const Text('Reset pencarian'),
                      ),
                    ],
                  ),
                ),

              ...items.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: wkmCardDecoration(radius: 10),
                  child: ExpansionTile(
                    iconColor: WkmColors.orange,
                    collapsedIconColor: WkmColors.muted,
                    title: Text(
                      item.question,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: WkmColors.dark,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.answer,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            height: 1.5,
                            color: WkmColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: wkmCardDecoration(
                  color: WkmColors.softOrange,
                  radius: 12,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.storefront_outlined, color: WkmColors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bantuan langsung tersedia di gerai Warkop Wong Kito terdekat.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: WkmColors.dark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
