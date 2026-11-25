# WKM Mobile — Wong Kito Mobile

Aplikasi mobile Flutter untuk pelanggan Warkop Wong Kito (WKM): menjelajahi menu, menyesuaikan pesanan, memesan, dan memantau status pesanan dari satu tempat.

> **Catatan penting:** aplikasi ini berjalan dengan data lokal/simulasi. Tidak ada backend, API, payment gateway, autentikasi server, atau database yang terhubung. Detail simulasi ada di bagian [Status Data & Pembayaran](#status-data--pembayaran).

## Fitur Utama

| Area | Fitur yang tersedia |
| --- | --- |
| **Onboarding & Akun** | Splash 2 detik, onboarding 3 slide, login dan register simulasi, lupa/reset password simulasi, logout. |
| **Dashboard** | Banner promo, kategori, rekomendasi menu, pencarian, dan akses ke detail menu. |
| **Menu** | Daftar menu lokal dengan kategori (`Semua`, `Kopi`, `Non-Kopi`, `Makanan`) dan jumlah item per kategori. |
| **Pencarian & Filter** | Pencarian nama/kategori, pencarian terakhir, filter kategori, rentang harga, pengurutan (`Relevan`, `Harga Termurah`, `Harga Termahal`), serta reset filter. |
| **Detail Menu** | Pilih level gula, extra shot (+Rp5.000), suhu penyajian, tipe pesanan (`Dine-in`/`Take Away`), nomor meja, jumlah pesanan, dan subtotal realtime. |
| **Promo** | Detail paket `Paket Hemat Kenyang` dari banner dashboard; paket bisa ditambahkan ke keranjang sebagai satu item. |
| **Keranjang** | Tambah/kurangi quantity, hapus item dengan konfirmasi dan aksi `Urungkan`, catatan per item, total otomatis, empty state, dan CTA lanjut checkout. |
| **Checkout** | Jenis pesanan, pemilihan meja, daftar item, catatan pesanan, metode pembayaran, konfirmasi untuk metode non-QRIS, dan empty state. |
| **Pembayaran** | Alur QRIS simulasi dengan kode demo, timer 15 menit, konfirmasi lokal, pembatalan, pengembalian item ke keranjang, serta error state saat konfirmasi gagal. |
| **Pesanan** | Halaman sukses, daftar pesanan dengan tab `Dalam Proses` dan `Riwayat`, detail pesanan, dan tracking status. |
| **Profil & Bantuan** | Edit profil, alamat, notifikasi, riwayat pesanan, bantuan/FAQ, dan pengaturan data demo saat logout. |

## Alur Pemesanan

Alur utama yang didukung aplikasi:

1. **Splash → Onboarding → Login/Register**
2. **Dashboard** (tab Beranda)
3. **Menu** (tab Menu) atau **Search** dari dashboard
4. **Detail Menu** — pilih customization dan quantity
5. **Tambah ke Keranjang** — pengguna tetap berada di halaman Detail Menu
6. **Cart** — periksa item, quantity, catatan, dan total
7. **Lanjut Checkout** — isi tipe pesanan, meja, catatan, dan metode pembayaran
8. **Payment** — hanya untuk QRIS; metode lain langsung ke halaman sukses
9. **Order Success** — ringkasan pesanan
10. **Tracking / Riwayat Pesanan** — pantau status atau lihat detail pesanan

Jalur promo: **Dashboard → banner promo → Detail Promo → tambah paket ke Cart → lanjut ke alur checkout**.

## Status Data & Pembayaran

| Komponen | Kondisi aktual di source code |
| --- | --- |
| Login / Register | Simulasi. Email dengan format valid dan kata sandi minimal 6 karakter diterima; tidak ada pengecekan kredensial ke server. |
| Lupa / Reset Password | Simulasi lokal: link dianggap terkirim dan password dianggap berhasil diubah. |
| Katalog menu | Disimpan lokal di `MenuRepository`; 7 menu contoh. |
| Metode pembayaran | `QRIS`, `E-Wallet Langsung`, dan `Bayar Kasir (Cash / Tunai)`. Semua status dikelola lokal. |
| QRIS | Kode QR adalah simulasi, bukan kode dari payment gateway. Pesanan dibuat sekali di checkout dengan status `Menunggu Pembayaran`; tombol **Saya Sudah Bayar** menandai pesanan menjadi `Lunas` secara lokal. |
| Pembatalan QRIS | Membatalkan pesanan dan mengembalikan item ke keranjang, termasuk saat timer 15 menit habis. |
| Pembayaran non-QRIS | Status `Lunas` ditandai lokal saat pesanan dibuat. Untuk cash, teks halaman sukses menyebut pembayaran dilakukan di kasir saat pengambilan. |
| Status pesanan | Alur simulasi: `Sedang Diproses` → `Siap Diantar` → `Selesai`. Tracking maju otomatis setiap 8 detik atau lewat tombol simulasi. |
| Riwayat & profil | Data demo in-memory; kembali ke kondisi awal saat aplikasi dijalankan ulang. |
| Rekomendasi & promo | Rekomendasi berasal dari beberapa menu lokal; promo `Paket Hemat Kenyang` dan harga paket bersifat contoh. |

## Teknologi

- Flutter dan Dart (`sdk: ^3.13.0`)
- Material 3
- `ChangeNotifier` dari Flutter Foundation untuk state lokal (tanpa package state management tambahan)
- Font lokal: Poppins dan Inter (`assets/fonts/`)
- Dependency: `flutter`, `cupertino_icons`, `google_fonts`, `flutter_test`, `flutter_lints`
- Tidak ada API, database, Firebase, atau layanan pembayaran eksternal

## Struktur Folder Ringkas

```text
lib/
├── data/                 # OrderStore: koordinasi cart, checkout, dan order
├── features/             # Model, repository, dan viewmodel per domain
│   ├── address/
│   ├── auth/
│   ├── dashboard/
│   ├── help/
│   ├── menu/
│   ├── notification/
│   ├── orders/
│   ├── profile/
│   └── search/
├── screens/              # Halaman UI per fitur
│   ├── address/
│   ├── help/
│   ├── home/
│   ├── login/
│   ├── menu/
│   ├── notification/
│   ├── onboarding/
│   ├── orders/
│   ├── profile/
│   ├── splash/
│   └── tracking/
├── theme/                # Token warna, tipografi, dan helper UI WKM
└── widgets/              # Widget bersama: navigasi, skeleton, cart icon
assets/
├── fonts/
└── images/
test/
├── features/
└── widget/
```

## Persyaratan

- Flutter SDK dengan Dart SDK `^3.13.0` atau lebih baru
- Android Studio / VS Code (opsional)
- Emulator Android atau perangkat Android yang terhubung

## Instalasi dan Menjalankan Aplikasi

```bash
git clone https://github.com/Dhoneew/wongkito-mobile-frontend.git
cd wongkito-mobile-frontend
flutter pub get
flutter run
```

Untuk melihat perangkat yang tersedia:

```bash
flutter devices
```

## Testing

Jalankan analisis statis dan test dari root folder proyek Flutter:

```bash
flutter analyze
flutter test
```

Test yang tersedia mencakup alur pencarian/filter, detail menu, keranjang, checkout, QRIS, pembayaran, sukses pesanan, detail pesanan, dan state skeleton/empty.

## Screenshot Aplikasi

Belum ada screenshot UI aplikasi yang disimpan di repository ini. Aset yang tersedia di `assets/images/` adalah ilustrasi onboarding, logo, dan gambar menu—bukan tangkapan layar aplikasi—sehingga tidak ditampilkan sebagai screenshot di README.

## Status Pengembangan

Aplikasi sudah memiliki alur pemesanan end-to-end berbasis simulasi lokal, mulai dari onboarding hingga tracking pesanan. Fitur yang melibatkan data nyata—login server, pembayaran sungguhan, notifikasi push, dan sinkronisasi pesanan—belum diimplementasikan.

## Pengembang

WKM Mobile — Wong Kito Mobile
