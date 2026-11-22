import '../models/help_item.dart';

class HelpRepository {
  final List<HelpItem> _helpItems = const [
    HelpItem(
      category: 'Pemesanan',
      question: 'Bagaimana cara memesan makanan?',
      answer:
          'Pilih menu yang diinginkan, tambahkan ke keranjang, '
          'kemudian lanjutkan ke checkout untuk menyelesaikan pesanan.',
    ),
    HelpItem(
      category: 'Pemesanan',
      question: 'Bagaimana cara melihat status pesanan?',
      answer:
          'Buka halaman Pesanan Saya, pilih pesanan yang ingin '
          'dilihat, kemudian periksa informasi status pada halaman Tracking.',
    ),
    HelpItem(
      category: 'Pembayaran',
      question: 'Metode pembayaran apa saja yang tersedia?',
      answer:
          'Metode pembayaran yang tersedia dapat dilihat pada '
          'halaman checkout aplikasi Wong Kito.',
    ),
    HelpItem(
      category: 'Pembayaran',
      question: 'Bagaimana jika pembayaran gagal?',
      answer:
          'Periksa kembali status pembayaran dan informasi transaksi '
          'sebelum mencoba melakukan pembayaran kembali.',
    ),
    HelpItem(
      category: 'Akun',
      question: 'Bagaimana cara mengubah informasi profil?',
      answer:
          'Buka halaman Profil Saya, pilih Edit Profil, ubah informasi '
          'yang diperlukan, kemudian tekan Simpan Perubahan.',
    ),
    HelpItem(
      category: 'Alamat',
      question: 'Bagaimana cara menambahkan alamat?',
      answer:
          'Buka halaman Profil Saya, pilih Alamat, kemudian tekan '
          'Tambah Alamat dan lengkapi informasi yang diminta.',
    ),
  ];

  List<HelpItem> getHelpItems() {
    return List.unmodifiable(_helpItems);
  }

  List<String> getCategories() {
    return ['Semua', ..._helpItems.map((item) => item.category).toSet()];
  }
}
