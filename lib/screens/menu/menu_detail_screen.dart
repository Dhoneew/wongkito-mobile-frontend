import '../../features/menu/viewmodels/menu_detail_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../data/order_store.dart';
import '../../features/orders/models/cart_item.dart';
import '../../features/orders/viewmodels/order_viewmodel.dart';
import '../../theme/wkm_style.dart';
import '../../widgets/cart_icon.dart';
import '../../widgets/wkm_skeleton.dart';
import '../orders/cart_screen.dart';

class MenuDetailScreen extends StatefulWidget {
  final String menuName;
  final String menuPrice;
  final String menuImage;
  final String? menuDescription;

  /// Optional loading/error state. Data lokal browser langsung tersedia,
  /// jadi skeleton hanya dipakai bila caller benar-benar sedang memuat.
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const MenuDetailScreen({
    super.key,
    this.menuName = 'Kopi Susu Wong Kito',
    this.menuPrice = 'Rp18.000',
    this.menuImage = 'assets/images/kopi_susu.png',
    this.menuDescription,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  late final OrderViewModel orderViewModel;
  late final MenuDetailViewModel viewModel;

  static const Color orange = WkmColors.orange;
  static const Color primaryOrange = WkmColors.orange;
  static const Color goldenOrange = Color(0xFFFFB74D);
  static const Color dark = WkmColors.dark;
  static const Color bg = WkmColors.background;
  static const Color secondaryText = WkmColors.muted;
  static const Color lightText = WkmColors.muted;

  /// Pesan validasi terakhir dipakai untuk petunjuk inline dekat field.
  /// Petunjuk otomatis hilang begitu pilihannya diisi.
  String? _validationError;

  @override
  void initState() {
    super.initState();

    orderViewModel = OrderStore.instance.viewModel;

    final digits = widget.menuPrice.replaceAll(RegExp(r'[^0-9]'), '');
    final price = int.tryParse(digits) ?? 18000;

    viewModel = MenuDetailViewModel(
      basePrice: price,
      orderType: orderViewModel.orderType == 'Take Away'
          ? 'Take Away (Bungkus)'
          : 'Dine-in (Makan di Tempat)',
      tableNumber: orderViewModel.tableNumber.isEmpty
          ? 'Meja 05'
          : orderViewModel.tableNumber,
    );
    viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String get menuDescription {
    final description = widget.menuDescription?.trim() ?? '';
    if (description.isNotEmpty) return description;
    return '${widget.menuName} dari Warkop Wong Kito, disiapkan segar sesuai pesananmu.';
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.dispose();
    super.dispose();
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
        actions: [
          WkmCartIcon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: widget.isLoading
            ? const WkmMenuDetailSkeleton()
            : widget.errorMessage != null
                ? _buildErrorState()
                : ListView(
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
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: dark,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    switchInCurve: Curves.easeOut,
                    child: Text(
                      wkmRupiah(viewModel.unitPrice),
                      key: ValueKey<int>(viewModel.unitPrice),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    menuDescription,
                    style: const TextStyle(
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
                  isSelected: viewModel.sugarLevel == 'Normal (100%)',
                  onTap: () {
                    viewModel.selectSugarLevel('Normal (100%)');
                  },
                ),
                const SizedBox(height: 8),
                _buildOptionItem(
                  title: 'Less Sugar (50%)',
                  isSelected: viewModel.sugarLevel == 'Less Sugar (50%)',
                  onTap: () {
                    viewModel.selectSugarLevel('Less Sugar (50%)');
                  },
                ),
                const SizedBox(height: 8),
                _buildOptionItem(
                  title: 'No Sugar (0%)',
                  isSelected: viewModel.sugarLevel == 'No Sugar (0%)',
                  onTap: () {
                    viewModel.selectSugarLevel('No Sugar (0%)');
                  },
                ),
                if (_validationError != null &&
                    _validationError!.contains('gula') &&
                    viewModel.sugarLevel == null) ...[
                  const SizedBox(height: 8),
                  _buildInlineHint('Pilih level gula untuk melanjutkan.'),
                ],
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
                  isSelected: viewModel.extraShot == false,
                  onTap: () {
                    viewModel.selectExtraShot(false);
                  },
                ),
                const SizedBox(height: 8),
                _buildOptionItem(
                  title: 'Extra Shot (+Rp5.000)',
                  trailingText: '+Rp5.000',
                  trailingBold: true,
                  isSelected: viewModel.extraShot == true,
                  onTap: () {
                    viewModel.selectExtraShot(true);
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
                        isSelected: viewModel.temperature == 'Ice (Dingin)',
                        onTap: () {
                          viewModel.selectTemperature('Ice (Dingin)');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOptionItem(
                        title: 'Hot (Panas)',
                        trailingIcon: Icons.local_fire_department,
                        isSelected: viewModel.temperature == 'Hot (Panas)',
                        onTap: () {
                          viewModel.selectTemperature('Hot (Panas)');
                        },
                      ),
                    ),
                  ],
                ),
                if (_validationError != null &&
                    _validationError!.contains('suhu') &&
                    viewModel.temperature == null) ...[
                  const SizedBox(height: 8),
                  _buildInlineHint('Pilih suhu penyajian untuk melanjutkan.'),
                ],
              ],
            ),

            const SizedBox(height: 10),

            // 4. TIPE PESANAN
            _buildSectionContainer(
              title: '4. Tipe Pesanan',
              badgeWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: WkmColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Pilih Cara Makan',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: secondaryText,
                  ),
                ),
              ),
              children: [
                _buildOptionItem(
                  title: 'Dine-in (Makan di Tempat)',
                  isSelected: viewModel.orderType == 'Dine-in (Makan di Tempat)',
                  onTap: () {
                    viewModel.selectOrderType('Dine-in (Makan di Tempat)');
                  },
                ),
                if (viewModel.orderType == 'Dine-in (Makan di Tempat)') ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: WkmColors.border),
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
                                  'Pilih Meja: ${viewModel.tableNumber}',
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
                  isSelected: viewModel.orderType == 'Take Away (Bungkus)',
                  onTap: () {
                    viewModel.selectOrderType('Take Away (Bungkus)');
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
                    height: 52,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: goldenOrange,
                      borderRadius: BorderRadius.circular(8),
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
                          onTap: viewModel.decreaseQuantity,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 17,
                              color: dark,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 42,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 140),
                            switchInCurve: Curves.easeOut,
                            child: Text(
                              '${viewModel.quantity}',
                              key: ValueKey<int>(viewModel.quantity),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: dark,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: viewModel.increaseQuantity,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 17,
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
                border: Border.all(color: WkmColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    viewModel.quantity == 0
                        ? 'Subtotal (0 item)'
                        : 'Subtotal (${viewModel.quantity} item'
                            '${viewModel.extraShot == true ? ' dengan extra shot' : ''})',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: secondaryText,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    switchInCurve: Curves.easeOut,
                    child: Text(
                      wkmRupiah(viewModel.subtotal),
                      key: ValueKey<int>(viewModel.subtotal),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // RINGKASAN CUSTOMISASI (compact, mengikuti pilihan realtime)
            _buildCustomizationSummary(),

            const SizedBox(height: 10),

            // TOMBOL TAMBAH KERANJANG
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: viewModel.quantity > 0 ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  disabledBackgroundColor: WkmColors.disabled,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  overlayColor: Colors.white24,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tambah ke Keranjang',
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

  /// Petunjuk validasi ringan di dekat komponen yang belum diisi.
  Widget _buildInlineHint(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: WkmColors.dangerSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 14, color: WkmColors.danger),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: WkmColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Ringkasan kecil di dekat subtotal supaya user bisa memindai pilihannya
  /// sebelum menambah ke keranjang.
  Widget _buildCustomizationSummary() {
    final customization = <String>[
      viewModel.sugarLevel ?? 'Gula belum dipilih',
      if (viewModel.extraShot == true) 'Extra Shot',
      viewModel.temperature ?? 'Suhu belum dipilih',
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: WkmColors.softOrange,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: WkmColors.warningBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.menuName,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: dark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            customization,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: secondaryText,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${viewModel.quantity} item',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                child: Text(
                  wkmRupiah(viewModel.subtotal),
                  key: ValueKey<int>(viewModel.subtotal),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Error state yang tenang: ikon sederhana, pesan jelas, satu aksi.
  Widget _buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: WkmColors.softOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_cafe_outlined,
                size: 34,
                color: orange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Detail menu belum tersedia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.errorMessage ?? 'Coba muat ulang detail menu ini.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed:
                    widget.onRetry ?? () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.refresh, size: 17),
                label: Text(
                  widget.onRetry != null ? 'Coba Lagi' : 'Kembali',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DIALOG PILIH MEJA (SESUAI GAMBAR)
  void _showTableSelectionDialog() {
    // Ambil nomor meja saat ini (misal "05" dari "Meja 05")
    String selectedTableDigits = viewModel.tableNumber.replaceAll(RegExp(r'[^0-9]'), '');
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.82,
                  ),
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
                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close, color: dark),
                            tooltip: 'Tutup',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Grid Meja 1 - 12 (3 kolom x 4 baris), bisa digulir
                      // pada layar pendek supaya CTA tidak tertutup.
                      Flexible(
                        child: SingleChildScrollView(
                          child: GridView.builder(
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
                                    ? WkmColors.muted
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
                        ),
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
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: dark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: WkmColors.muted,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Tidak Tersedia',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
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
                          width: 180,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.selectTableNumber('Meja $selectedTableDigits');
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
      border: Border.all(color: WkmColors.border),
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
                    color: WkmColors.muted,
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

  // RADIO BUTTON INDIKATOR — orange saat dipilih, netral saat tidak.
  Widget _buildRadioIndicator(bool isSelected) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? orange : WkmColors.disabled,
          width: 1.6,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: orange,
                ),
              ),
            )
          : null,
    );
  }

  // OPSI ITEM PILIHAN — transisi halus pada background & border.
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: 46),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? WkmColors.softOrange : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? orange : WkmColors.border,
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: isSelected
              ? null
              : [
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
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
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
                  color: trailingBold
                      ? (isSelected ? orange : dark)
                      : WkmColors.muted,
                ),
              ),
            if (trailingIcon != null)
              Icon(
                trailingIcon,
                size: 19,
                color: isSelected ? orange : dark,
              ),
          ],
        ),
      ),
    );
  }

  // TAMBAH MENU KE KERANJANG
  void _addToCart() {
    final validationMessage = viewModel.validateOrder();

    if (validationMessage != null) {
      setState(() => _validationError = validationMessage);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline,
                    size: 17, color: WkmColors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    validationMessage,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: WkmColors.dark,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      return;
    }

    _validationError = null;

    orderViewModel.setOrderType(viewModel.orderType);
    if (viewModel.orderType.startsWith('Dine-in')) {
      orderViewModel.setTableNumber(viewModel.tableNumber);
    }

    orderViewModel.addItem(
      CartItem(
        menuName: widget.menuName,
        menuImage: widget.menuImage,
        price: viewModel.basePrice,
        sugarLevel: viewModel.sugarLevel!,
        extraShot: viewModel.extraShot == true,
        temperature: viewModel.temperature!,
        quantity: viewModel.quantity,
      ),
    );

    // Hanya memasukkan item ke keranjang. User boleh lanjut memilih menu lain;
    // checkout tetap hanya bisa dilakukan dari halaman Cart.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: orange, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${widget.menuName} berhasil ditambahkan ke keranjang',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: WkmColors.dark,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Lihat Keranjang',
            textColor: orange,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ),
      );
  }
}
