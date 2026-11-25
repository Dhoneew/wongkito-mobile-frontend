import 'package:flutter/material.dart';

/// Design tokens bersama untuk seluruh aplikasi Warkop Wong Kito.
/// Warna dan bentuk di sini mengikuti identitas visual yang sudah dipakai
/// pada halaman-halaman utama, sehingga tidak ada halaman yang "nyelip".
abstract final class WkmColors {
  static const orange = Color(0xFFF79F1A);
  static const background = Color(0xFFFAF9F9);
  static const dark = Color(0xFF1A1C1C);
  static const muted = Color(0xFF757575);
  static const border = Color(0xFFEEEEEE);
  static const disabled = Color(0xFFCCCCCC);
  static const softOrange = Color(0xFFFFF3E0);
  static const success = Color(0xFF2E7D32);
  static const successSoft = Color(0xFFE8F5E9);
  static const danger = Color(0xFFD32F2F);
  static const dangerSoft = Color(0xFFFFEBEE);

  /// Warna pendukung yang dipakai berulang di QRIS, hint, dan timeline.
  static const hint = Color(0xFFAAAAAA);
  static const warningSoft = Color(0xFFFFF4E8);
  static const warningBorder = Color(0xFFFFD6B0);
  static const qrisRed = Color(0xFFED1C24);
  static const progress = Color(0xFFFFCC80);
}

/// Format rupiah yang konsisten di semua halaman.
String wkmRupiah(int value) {
  return 'Rp${value.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => '.',
      )}';
}

BoxDecoration wkmCardDecoration({
  Color color = Colors.white,
  double radius = 12,
  bool border = true,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: border ? Border.all(color: WkmColors.border, width: 0.8) : null,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.035),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );
}

/// Tombol utama WKM dengan tinggi dan radius yang seragam.
Widget wkmPrimaryButton({
  required String label,
  required VoidCallback? onPressed,
  bool loading = false,
  double height = 50,
  IconData? icon,
}) {
  return SizedBox(
    width: double.infinity,
    height: height,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: WkmColors.orange,
        disabledBackgroundColor: WkmColors.disabled,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
    ),
  );
}

/// Tombol sekunder (outline orange) dengan ukuran yang seragam.
Widget wkmOutlineButton({
  required String label,
  required VoidCallback? onPressed,
  double height = 48,
}) {
  return SizedBox(
    width: double.infinity,
    height: height,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: WkmColors.orange, width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: WkmColors.orange,
        ),
      ),
    ),
  );
}

/// Header halaman dengan tombol kembali yang konsisten.
Widget wkmAppBarTitle(String title, {String? subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: WkmColors.dark,
        ),
      ),
      if (subtitle != null)
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: WkmColors.muted,
          ),
        ),
    ],
  );
}

/// Back button standar dengan target sentuh minimal 44x44.
Widget wkmBackButton(VoidCallback onPressed, {Color color = WkmColors.dark}) {
  return IconButton(
    onPressed: onPressed,
    icon: Icon(Icons.chevron_left, size: 28, color: color),
    tooltip: 'Kembali',
  );
}

/// Status pesanan tidak boleh hanya dibedakan oleh warna. Helper ini dipakai
/// di daftar pesanan, detail, dan tracking supaya ikon + teksnya konsisten.
IconData wkmStatusIcon(String status) {
  switch (status) {
    case 'Selesai':
      return Icons.check_circle_outline;
    case 'Dibatalkan':
      return Icons.cancel_outlined;
    case 'Siap Diambil':
    case 'Siap':
      return Icons.assignment_turned_in_outlined;
    case 'Sedang Diproses':
    default:
      return Icons.hourglass_top;
  }
}

Color wkmStatusColor(String status) {
  switch (status) {
    case 'Selesai':
      return WkmColors.success;
    case 'Dibatalkan':
      return WkmColors.danger;
    case 'Siap Diambil':
    case 'Siap':
      return WkmColors.orange;
    case 'Sedang Diproses':
    default:
      return WkmColors.dark;
  }
}

/// Tanggal pesanan: menerima both ISO string dan format teks lama.
String wkmFormatOrderDate(String raw) {
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return raw;

  final months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  final time =
      '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
  return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year} · $time';
}
