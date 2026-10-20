import 'package:flutter/material.dart';

import '../../data/order_store.dart';
import '../orders/checkout_screen.dart';

class MenuDetailScreen extends StatefulWidget {
  final String menuName;
  final String menuPrice;
  final String menuImage;

  const MenuDetailScreen({
    super.key,
    this.menuName = 'Kopi Susu Wong Kito',
    this.menuPrice = 'Rp18.000',
    this.menuImage = 'assets/images/kopi_susu.png',
  });

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  static const Color orange = Color(0xFFFF6200);
  static const Color primaryOrange = Color(0xFFFF5E00);
  static const Color goldenOrange = Color(0xFFF79F1A);
  static const Color dark = Color(0xFF1A1C1C);
  static const Color bg = Color(0xFFFAF9F9);
  static const Color secondaryText = Color(0xFF666666);
  static const Color lightText = Color(0xFF888888);

  String? sugarLevel;
  bool? extraShot;
  String? temperature;
  String orderType = 'Dine-in (Makan di Tempat)';
  String tableNumber = 'Meja 05';

  int quantity = 0;

  int get basePrice {
    final digits = widget.menuPrice.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 18000;
  }

  int get unitPrice => basePrice + (extraShot == true ? 5000 : 0);

  int get subtotal => quantity * unitPrice;

  String rupiah(int value) {
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    return 'Rp$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: dark),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Detail Menu',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // FOTO MENU
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.menuImage,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    color: const Color(0xFFFFE0C2),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.local_cafe,
                      size: 80,
                      color: goldenOrange,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // INFORMASI PRODUK
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.menuName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: dark,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          'TERSEDIA',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: dark,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.menuPrice,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Kopi susu dengan perpaduan espresso robusta dan susu gula aren khas warkop.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: secondaryText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 1. LEVEL GULA
            _buildSectionContainer(
              title: '1. Level Gula',
              badge: 'Wajib (1)',
              children: [
                _buildOptionItem(
                  title: 'Normal (100%)',
                  trailingText: 'Rekomendasi',
                  isSelected: sugarLevel == 'Normal (100%)',
                  onTap: () {
                    setState(() {
                      sugarLevel = 'Normal (100%)';
                    });
                  },
                ),
                const SizedBox(height: 8),
                _buildOptionItem(
                  title: 'Less Sugar (50%)',
                  isSelected: sugarLevel == 'Less Sugar (50%)',
                  onTap: () {
                    setState(() {
                      sugarLevel = 'Less Sugar (50%)';
                    });
                  },
                ),
                const SizedBox(height: 8),
                _buildOptionItem(
                  title: 'No Sugar (0%)',
                  isSelected: sugarLevel == 'No Sugar (0%)',
                  onTap: () {
                    setState(() {
                      sugarLevel = 'No Sugar (0%)';
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 2. EXTRA SHOT ESPRESSO
            _buildSectionContainer(
              title: '2. Extra Shot Espresso',
              badge: 'Opsional',
              children: [
                _buildOptionItem(
                  title: 'Tidak',
                  trailingText: 'Rp0',
                  isSelected: extraShot == false,
                  onTap: () {
                    setState(() {
                      extraShot = false;
                    });
                  },
                ),
                const SizedBox(height: 8),
                _buildOptionItem(
                  title: 'Extra Shot (+Rp5.000)',
                  trailingText: '+Rp5.000',
                  trailingBold: true,
                  isSelected: extraShot == true,
                  onTap: () {
                    setState(() {
                      extraShot = true;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 3. SUHU PENYAJIAN
            _buildSectionContainer(
              title: '3. Suhu Penyajian',
              badge: 'Wajib',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildOptionItem(
                        title: 'Ice (Dingin)',
                        trailingIcon: Icons.ac_unit,
                        isSelected: temperature == 'Ice (Dingin)',
                        onTap: () {
                          setState(() {
                            temperature = 'Ice (Dingin)';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOptionItem(
                        title: 'Hot (Panas)',
                        trailingIcon: Icons.local_fire_department,
                        isSelected: temperature == 'Hot (Panas)',
                        onTap: () {
                          setState(() {
                            temperature = 'Hot (Panas)';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 4. TIPE PESANAN
            _buildSectionContainer(
              title: '4. Tipe Pesanan',
              badgeWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Pilih Cara Makan',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: secondaryText,
                  ),
                ),
              ),
              children: [
                _buildOptionItem(
                  title: 'Dine-in (Makan di Tempat)',
                  isSelected: orderType == 'Dine-in (Makan di Tempat)',
                  onTap: () {
                    setState(() {
                      orderType = 'Dine-in (Makan di Tempat)';
                    });
                  },
                ),
                if (orderType == 'Dine-in (Makan di Tempat)') ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NOMOR MEJA',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: secondaryText,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: _showTableSelectionDialog,
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: double.infinity,
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: goldenOrange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pilih Meja: $tableNumber',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: dark,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: dark,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                _buildOptionItem(
                  title: 'Take Away (Bungkus)',
                  isSelected: orderType == 'Take Away (Bungkus)',
                  onTap: () {
                    setState(() {
                      orderType = 'Take Away (Bungkus)';
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // JUMLAH
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: _cardDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jumlah',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: dark,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Atur porsi pesanan',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: lightText,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 42,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: goldenOrange,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            if (quantity > 0) {
                              setState(() => quantity--);
                            }
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 16,
                              color: dark,
                            ),
                          ),
                        ),
                        Container(
                          width: 44,
                          alignment: Alignment.center,
                          child: Text(
                            '$quantity',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: dark,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() => quantity++);
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: dark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // SUBTOTAL
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    quantity == 0
                        ? 'Subtotal (0 items with extra shot)'
                        : 'Subtotal ($quantity item${quantity == 1 ? '' : 's'}${extraShot == true ? ' with extra shot' : ''})',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: secondaryText,
                    ),
                  ),
                  Text(
                    quantity == 0 ? 'Rp0.000' : rupiah(subtotal),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // TOMBOL TAMBAH KERANJANG
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'TAMBAH KERANJANG',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // DIALOG PILIH MEJA (SESUAI GAMBAR)
  void _showTableSelectionDialog() {
    // Ambil nomor meja saat ini (misal "05" dari "Meja 05")
    String selectedTableDigits = tableNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (selectedTableDigits.isEmpty) selectedTableDigits = '05';

    // Meja tidak tersedia sesuai tampilan gambar (06, 08, 10)
    const Set<String> unavailableTables = {'06', '08', '10'};

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pilih Meja :',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: dark,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(dialogContext),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                'X',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: dark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Grid Meja 1 - 12 (3 kolom x 4 baris)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 12,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, index) {
                          final tableDigits =
                              (index + 1).toString().padLeft(2, '0');
                          final isUnavailable =
                              unavailableTables.contains(tableDigits);
                          final isSelected =
                              selectedTableDigits == tableDigits;

                          return GestureDetector(
                            onTap: isUnavailable
                                ? null
                                : () {
                                    setModalState(() {
                                      selectedTableDigits = tableDigits;
                                    });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isUnavailable
                                    ? const Color(0xFFA0A3A8)
                                    : primaryOrange,
                                borderRadius: BorderRadius.circular(16),
                                border: isSelected
                                    ? Border.all(
                                        color: dark,
                                        width: 2.5,
                                      )
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                tableDigits,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: dark,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Keterangan Status Meja
                      Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: primaryOrange,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Tersedia',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: dark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFFA0A3A8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Tidak Tersedia',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: dark,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Tombol Konfirmasi Meja
                      Center(
                        child: SizedBox(
                          width: 170,
                          height: 38,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                tableNumber = 'Meja $selectedTableDigits';
                              });
                              Navigator.pop(dialogContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryOrange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text(
                              'Pilih Meja $selectedTableDigits',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // DEKORASI KARTU UTAMA
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFEAEAEA)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // CONTAINER UNTUK SETIAP BAGIAN
  Widget _buildSectionContainer({
    required String title,
    String? badge,
    Widget? badgeWidget,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),
              if (badgeWidget != null)
                badgeWidget
              else if (badge != null)
                Text(
                  badge,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Color(0xFF555555),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  // RADIO BUTTON INDIKATOR (SESUAI GAMBAR)
  Widget _buildRadioIndicator(bool isSelected) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? dark : const Color(0xFF888888),
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: dark,
                ),
              ),
            )
          : null,
    );
  }

  // OPSI ITEM PILIHAN
  Widget _buildOptionItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    String? trailingText,
    bool trailingBold = false,
    IconData? trailingIcon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildRadioIndicator(isSelected),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: dark,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight:
                      trailingBold ? FontWeight.bold : FontWeight.normal,
                  color: trailingBold ? dark : const Color(0xFF777777),
                ),
              ),
            if (trailingIcon != null)
              Icon(
                trailingIcon,
                size: 19,
                color: dark,
              ),
          ],
        ),
      ),
    );
  }

  // TAMBAH MENU KE KERANJANG
  void _addToCart() {
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan tambahkan jumlah pesanan minimal 1'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    OrderStore.instance.orderType = orderType;
    OrderStore.instance.tableNumber = tableNumber;

    OrderStore.instance.addItem(
      CartItem(
        menuName: widget.menuName,
        menuImage: widget.menuImage,
        price: basePrice,
        sugarLevel: sugarLevel ?? 'Normal (100%)',
        extraShot: extraShot == true,
        temperature: temperature ?? 'Ice (Dingin)',
        quantity: quantity,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutScreen(),
      ),
    );
  }
}
