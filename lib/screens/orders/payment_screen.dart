import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/order_store.dart';
import '../tracking/tracking_screen.dart';

class PaymentCodeScreen extends StatefulWidget {
  final String orderId;
  final int totalAmount;

  const PaymentCodeScreen({
    super.key,
    this.orderId = 'WK-005',
    this.totalAmount = 36000,
  });

  @override
  State<PaymentCodeScreen> createState() => _PaymentCodeScreenState();
}

class _PaymentCodeScreenState extends State<PaymentCodeScreen> {
  static const Color orange = Color(0xFFFF6200);
  static const Color dark = Color(0xFF1A1C1C);
  static const Color bg = Color(0xFFFAF9F9);
  static const Color secondaryText = Color(0xFF666666);

  int _remainingSeconds = 15 * 60; // 15 minutes
  Timer? _timer;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTimer {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String rupiah(int value) {
    return 'Rp${value.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (_) => '.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final amountToPay = widget.totalAmount > 0
        ? widget.totalAmount
        : (OrderStore.instance.cartTotal > 0
            ? OrderStore.instance.cartTotal
            : 36000);

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
          'Kode Pembayaran',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                children: [
                  // BANNER COUNTDOWN TIMER
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFFD6B0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Selesaikan pembayaran dalam',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: dark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: orange,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _formattedTimer,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // KARTU UTAMA QRIS
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header QRIS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFED1C24),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Text(
                                    'QRIS',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                      color: Colors.white,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Pembayaran Nasional',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    color: secondaryText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 11, color: Color(0xFF2E7D32)),
                                  SizedBox(width: 3),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Nama Merchant
                        const Text(
                          'WARKOP WONG KITO',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: dark,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Text(
                          'NMID: ID10202610200506',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            color: secondaryText,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // WIDGET KODE QR (Crisp & Aesthetic)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: 210,
                            height: 210,
                            child: CustomPaint(
                              painter: _QrisPainter(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // TOMBOL SIMPAN KODE QR (Sesuai Gambar tapi Lebih Rapi)
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: _saveQrCode,
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text(
                              'Simpan kode QR',
                              style: TextStyle(
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

                        const SizedBox(height: 10),
                        const Text(
                          'Bisa dipindai dari GoPay, OVO, DANA, ShopeePay, BCA, Livin & semua bank.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            color: secondaryText,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // KARTU RINCIAN PEMBAYARAN
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL PEMBAYARAN',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: secondaryText,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              rupiah(amountToPay),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: orange,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: amountToPay.toString()),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Nominal berhasil disalin!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.copy, size: 12, color: dark),
                                    SizedBox(width: 4),
                                    Text(
                                      'Salin',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: dark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        _detailRow('ID Pesanan', widget.orderId),
                        const SizedBox(height: 6),
                        _detailRow('Metode', 'QRIS Dinamis'),
                        const SizedBox(height: 6),
                        _detailRow('Waktu Transaksi', '20 Okt 2026, 17:05 WIB'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // CARA PEMBAYARAN (ACCORDION)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: false,
                        title: const Text(
                          'Cara Pembayaran QRIS',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: dark,
                          ),
                        ),
                        leading: const Icon(Icons.help_outline, color: orange),
                        children: const [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _StepItem(
                                  number: '1',
                                  text:
                                      'Buka aplikasi m-Banking (BCA, Mandiri, BRI, BNI) atau E-Wallet (GoPay, OVO, DANA, ShopeePay).',
                                ),
                                _StepItem(
                                  number: '2',
                                  text:
                                      'Pilih menu "Bayar" atau "Scan / Pindai QRIS".',
                                ),
                                _StepItem(
                                  number: '3',
                                  text:
                                      'Arahkan kamera ke kode QR di atas, atau klik "Simpan kode QR" lalu unggah dari galeri foto.',
                                ),
                                _StepItem(
                                  number: '4',
                                  text:
                                      'Periksa nama merchant: Warkop Wong Kito dan pastikan jumlah tagihan sesuai.',
                                ),
                                _StepItem(
                                  number: '5',
                                  text:
                                      'Masukkan PIN Anda dan konfirmasi pembayaran.',
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

            // TOMBOL AKSI BAWAH
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _confirmPaymentSuccess,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'SAYA SUDAH BAYAR',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Batalkan / Ganti Pembayaran',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: secondaryText,
                      ),
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

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: secondaryText,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: dark,
          ),
        ),
      ],
    );
  }

  void _saveQrCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Kode QR berhasil disimpan ke Galeri!'),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _confirmPaymentSuccess() async {
    setState(() => _isProcessing = true);

    // Simulasi verifikasi sistem pembayaran 1.2 detik
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    // Lakukan checkout di store jika ada item di keranjang
    OrderStore.instance.checkout();

    setState(() => _isProcessing = false);

    // Dialog Sukses
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E7D32),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pembayaran Berhasil!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Terima kasih! Pesanan #${widget.orderId} sedang disiapkan oleh barista.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: secondaryText,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  // Buka halaman tracking
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TrackingScreen(
                        orderId: widget.orderId,
                        total: widget.totalAmount,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lihat Status Pesanan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ITEM STEP PANDUAN
class _StepItem extends StatelessWidget {
  final String number;
  final String text;

  const _StepItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE8C5),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6200),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFF444444),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// REALISTIC VECTOR QRIS PAINTER (Presisi & Tajam)
class _QrisPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintDark = Paint()
      ..color = const Color(0xFF1A1C1C)
      ..style = PaintingStyle.fill;

    final paintWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // 25 x 25 grid modules
    const int count = 25;
    final double cellSize = size.width / count;

    void drawSquare(int col, int row, int w, int h, Paint paint) {
      canvas.drawRect(
        Rect.fromLTWH(col * cellSize, row * cellSize, w * cellSize, h * cellSize),
        paint,
      );
    }

    // 1. Tiga Finder Patterns di Sudut (Top-Left, Top-Right, Bottom-Left)
    void drawFinder(int startCol, int startRow) {
      // 7x7 outer black
      drawSquare(startCol, startRow, 7, 7, paintDark);
      // 5x5 inner white
      drawSquare(startCol + 1, startRow + 1, 5, 5, paintWhite);
      // 3x3 inner black
      drawSquare(startCol + 2, startRow + 2, 3, 3, paintDark);
    }

    drawFinder(0, 0); // Top Left
    drawFinder(count - 7, 0); // Top Right
    drawFinder(0, count - 7); // Bottom Left

    // 2. Timing Patterns
    for (int i = 8; i < count - 8; i++) {
      if (i % 2 == 0) {
        drawSquare(6, i, 1, 1, paintDark);
        drawSquare(i, 6, 1, 1, paintDark);
      }
    }

    // 3. Alignment Pattern (kanan bawah)
    drawSquare(count - 9, count - 9, 5, 5, paintDark);
    drawSquare(count - 8, count - 8, 3, 3, paintWhite);
    drawSquare(count - 7, count - 7, 1, 1, paintDark);

    // 4. Modul Data QR yang Realistis
    final pattern = [
      0x1A2B3C4D, 0x5E6F7081, 0x92A3B4C5, 0xD6E7F809,
      0x12345678, 0x9ABCDEF0, 0x2468ACE0, 0x13579BDF,
      0x0F1E2D3C, 0x4B5A6978, 0x8796A5B4, 0xC3D2E1F0,
      0xA5A5A5A5, 0x5A5A5A5A, 0x3C3C3C3C, 0xC3C3C3C3,
    ];

    for (int r = 0; r < count; r++) {
      for (int c = 0; c < count; c++) {
        // Skip finder areas
        if ((r < 8 && c < 8) ||
            (r < 8 && c >= count - 8) ||
            (r >= count - 8 && c < 8)) {
          continue;
        }
        // Skip timing
        if (r == 6 || c == 6) continue;
        // Skip alignment
        if (r >= count - 9 && r <= count - 5 && c >= count - 9 && c <= count - 5) {
          continue;
        }
        // Skip center logo cutout (10x10 to 14x14)
        if (r >= 10 && r <= 14 && c >= 10 && c <= 14) continue;

        final hash = (r * 31 + c * 17) ^ pattern[(r + c) % pattern.length];
        if (hash % 3 == 0 || hash % 7 == 1) {
          drawSquare(c, r, 1, 1, paintDark);
        }
      }
    }

    // 5. Logo Center Badge (Coffee Icon Warkop)
    final centerRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cellSize * 5.4,
      height: cellSize * 5.4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(centerRect, const Radius.circular(5)),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(centerRect, const Radius.circular(5)),
      Paint()
        ..color = const Color(0xFFFF6200)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Gambar simbol mini kopi di tengah
    final iconPaint = Paint()
      ..color = const Color(0xFFFF6200)
      ..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - 2, cy + 2), width: 14, height: 12),
        const Radius.circular(2),
      ),
      iconPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + 6, cy + 2), width: 8, height: 8),
      -1.5,
      3.0,
      false,
      Paint()
        ..color = const Color(0xFFFF6200)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

