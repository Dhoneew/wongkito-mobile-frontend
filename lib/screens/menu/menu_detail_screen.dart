
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
    this.menuImage = 'assets/images/Onboarding1.png',
  });

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  static const Color orange = Color(0xFFF79F1A);
  static const Color dark = Color(0xFF1A1C1C);
  static const Color bg = Color(0xFFFAF9F9);
  static const Color secondaryText = Color(0xFF666666);

  String sugarLevel = 'Normal (100%)';
  bool extraShot = false;
  String temperature = 'Ice (Dingin)';
  String orderType = 'Dine-in (Makan di Tempat)';
  String tableNumber = 'Meja 05';

  int quantity = 0;

  int get basePrice {
    final digits = widget.menuPrice.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 18000;
  }

  int get unitPrice => basePrice + (extraShot ? 5000 : 0);

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
        foregroundColor: dark,
        elevation: 1,
        title: const Text(
          'Detail Menu',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(17, 16, 17, 16),
                children: [
                  // FOTO MENU
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      widget.menuImage,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 220,
                          width: double.infinity,
                          color: const Color(0xFFFFE0C2),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.local_cafe,
                            size: 80,
                            color: orange,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // INFORMASI MENU
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.menuName,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'TERSEDIA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF34854A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.menuPrice,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: dark,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Kopi susu dengan perpaduan espresso robusta '
                          'dan susu gula aren khas warkop.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            height: 1.5,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 19),

                  // 1. LEVEL GULA
                  _buildSection(
                    title: '1. Level Gula',
                    badge: 'Wajib (1)',
                    child: Column(
                      children: [
                        _buildOption(
                          title: 'Normal (100%)',
                          selected: sugarLevel == 'Normal (100%)',
                          trailing: 'Rekomendasi',
                          onTap: () {
                            setState(() {
                              sugarLevel = 'Normal (100%)';
                            });
                          },
                        ),
                        _buildOption(
                          title: 'Less Sugar (50%)',
                          selected: sugarLevel == 'Less Sugar (50%)',
                          onTap: () {
                            setState(() {
                              sugarLevel = 'Less Sugar (50%)';
                            });
                          },
                        ),
                        _buildOption(
                          title: 'No Sugar (0%)',
                          selected: sugarLevel == 'No Sugar (0%)',
                          onTap: () {
                            setState(() {
                              sugarLevel = 'No Sugar (0%)';
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 2. EXTRA SHOT
                  _buildSection(
                    title: '2. Extra Shot Espresso',
                    badge: 'Opsional',
                    child: Column(
                      children: [
                        _buildOption(
                          title: 'Tidak',
                          selected: !extraShot,
                          trailing: 'Rp0',
                          onTap: () {
                            setState(() {
                              extraShot = false;
                            });
                          },
                        ),
                        _buildOption(
                          title: 'Extra Shot (+Rp5.000)',
                          selected: extraShot,
                          trailing: '+Rp5.000',
                          onTap: () {
                            setState(() {
                              extraShot = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 3. SUHU PENYAJIAN
                  _buildSection(
                    title: '3. Suhu Penyajian',
                    badge: 'Wajib',
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildOption(
                            title: 'Ice (Dingin)',
                            selected: temperature == 'Ice (Dingin)',
                            trailing: '❄',
                            onTap: () {
                              setState(() {
                                temperature = 'Ice (Dingin)';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildOption(
                            title: 'Hot (Panas)',
                            selected: temperature == 'Hot (Panas)',
                            trailing: '♨',
                            onTap: () {
                              setState(() {
                                temperature = 'Hot (Panas)';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 4. TIPE PESANAN
                  _buildSection(
                    title: '4. Tipe Pesanan',
                    badge: 'Wajib',
                    child: Column(
                      children: [
                        _buildOption(
                          title: 'Dine-in (Makan di Tempat)',
                          selected:
                              orderType == 'Dine-in (Makan di Tempat)',
                          onTap: () {
                            setState(() {
                              orderType = 'Dine-in (Makan di Tempat)';
                            });
                          },
                        ),

                        if (orderType == 'Dine-in (Makan di Tempat)')
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NOMOR MEJA',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryText,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                DropdownButtonFormField<String>(
                                  value: tableNumber,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFFFC266),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: List.generate(10, (index) {
                                    final number = (index + 1)
                                        .toString()
                                        .padLeft(2, '0');

                                    return DropdownMenuItem<String>(
                                      value: 'Meja $number',
                                      child: Text(
                                        'Pilih Meja: Meja $number',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  }),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      tableNumber = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                        _buildOption(
                          title: 'Take Away (Bungkus)',
                          selected: orderType == 'Take Away (Bungkus)',
                          onTap: () {
                            setState(() {
                              orderType = 'Take Away (Bungkus)';
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // JUMLAH PESANAN
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: _cardDecoration(),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: dark,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Atur porsi pesanan',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: orange, width: 2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _quantityButton(
                                icon: Icons.remove,
                                onTap: () {
                                  if (quantity > 0) {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                width: 42,
                                child: Center(
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: dark,
                                    ),
                                  ),
                                ),
                              ),
                              _quantityButton(
                                icon: Icons.add,
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // SUBTOTAL
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    decoration: _cardDecoration(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Subtotal ($quantity item'
                            '${quantity == 1 ? '' : 's'}'
                            '${extraShot ? ' dengan extra shot' : ''})',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: secondaryText,
                            ),
                          ),
                        ),
                        Text(
                          rupiah(subtotal),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // TOMBOL TAMBAH KERANJANG
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(17, 10, 17, 14),
              color: bg,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: quantity > 0 ? _addToCart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    disabledBackgroundColor: orange.withOpacity(0.45),
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAMBAH MENU KE KERANJANG
  void _addToCart() {
    if (quantity <= 0) return;

    OrderStore.instance.addItem(
      CartItem(
        menuName: widget.menuName,
        menuImage: widget.menuImage,
        price: basePrice,
        sugarLevel: sugarLevel,
        extraShot: extraShot,
        temperature: temperature,
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

  // DEKORASI KARTU
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // BAGIAN PILIHAN MENU
  Widget _buildSection({
    required String title,
    required String badge,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 9),
      decoration: BoxDecoration(
        color: orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: dark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // OPSI PILIHAN
  Widget _buildOption({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    String? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: selected ? true : null,
                  toggleable: false,
                  activeColor: dark,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  onChanged: (_) => onTap(),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: dark,
                        ),
                      ),
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 5),
                  Text(
                    trailing,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: trailing.startsWith('+')
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: secondaryText,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TOMBOL TAMBAH DAN KURANGI JUMLAH
  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(3),
        child: SizedBox(
          width: 38,
          height: 40,
          child: Icon(
            icon,
            size: 18,
            color: dark,
          ),
        ),
      ),
    );
  }
}
