
import 'package:flutter/material.dart';

import '../../features/help/repositories/help_repository.dart';
import '../../features/help/viewmodels/help_viewmodel.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  static const Color orange = Color(0xFFFF6200);
  static const Color backgroundColor = Color(0xFFFAF9F9);
  static const Color textColor = Color(0xFF1A1C1C);

  late final HelpViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HelpViewModel(HelpRepository());
    viewModel.loadHelpItems();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
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
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Ada yang bisa kami bantu?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                onChanged: viewModel.updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Cari pertanyaan...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: orange,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFEAEAEA),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFEAEAEA),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: viewModel.categories.map((category) {
                    final selected =
                        viewModel.selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) {
                          viewModel.selectCategory(category);
                        },
                        selectedColor: orange,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: selected ? Colors.white : textColor,
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
                  color: textColor,
                ),
              ),

              const SizedBox(height: 10),

              if (viewModel.filteredHelpItems.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Pertanyaan tidak ditemukan.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                ),

              ...viewModel.filteredHelpItems.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFEAEAEA),
                    ),
                  ),
                  child: ExpansionTile(
                    iconColor: orange,
                    collapsedIconColor: const Color(0xFF888888),
                    title: Text(
                      item.question,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(
                      16, 0, 16, 16,
                    ),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.answer,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            height: 1.5,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
