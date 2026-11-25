import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_user/data/order_store.dart';
import 'package:mobile_user/features/orders/models/cart_item.dart';
import 'package:mobile_user/features/orders/repositories/order_repository.dart';
import 'package:mobile_user/features/orders/viewmodels/order_viewmodel.dart';
import 'package:mobile_user/features/orders/viewmodels/tracking_viewmodel.dart';

CartItem createItem() {
  return CartItem(
    menuName: 'Kopi Susu',
    menuImage: 'assets/images/kopi_susu.png',
    price: 18000,
    sugarLevel: 'Normal (100%)',
    extraShot: false,
    temperature: 'Ice (Dingin)',
    quantity: 1,
    note: 'Es sedikit',
  );
}

void main() {
  group('Alur pesanan', () {
    test('OrderStore.checkout mengembalikan id pesanan bertipe String?', () {
      // Deklarasi ini mengunci signature agar halaman checkout bisa memakai
      // nilai kembalian (bug sebelumnya: OrderStore.checkout() bertipe void).
      final String? orderId = OrderStore.instance.checkout();
      expect(orderId, isNull);
    });

    test('cancelOrder mengembalikan item ke keranjang dan menghapus pesanan', () {
      final repository = OrderRepository();
      repository.setKitchenNote('Tanpa sambal');
      repository.addItem(createItem());
      final orderId = repository.checkout();

      expect(orderId, isNotNull);
      expect(repository.cart, isEmpty);
      expect(repository.kitchenNote, isEmpty);

      final cancelled = repository.cancelOrder(orderId!);

      expect(cancelled, isTrue);
      expect(repository.orders, isEmpty);
      expect(repository.cart, hasLength(1));
      expect(repository.cart.first.note, 'Es sedikit');
      expect(repository.kitchenNote, 'Tanpa sambal');
    });

    test('cancelOrder menolak pesanan yang sudah selesai', () {
      final repository = OrderRepository();
      repository.addItem(createItem());
      final orderId = repository.checkout()!;
      repository.updateOrderStatus(orderId, 'Selesai');

      expect(repository.cancelOrder(orderId), isFalse);
      expect(repository.orders, hasLength(1));
    });

    test('updateOrderStatus memperbarui pesanan baru dan mock history', () {
      final repository = OrderRepository();
      repository.addItem(createItem());
      final orderId = repository.checkout()!;

      repository.updateOrderStatus(orderId, 'Siap Diantar');
      expect(repository.getOrderById(orderId)?.status, 'Siap Diantar');

      repository.updateOrderStatus('WK-001', 'Siap Diantar');
      expect(repository.getOrderById('WK-001')?.status, 'Siap Diantar');
    });

    test('TrackingViewModel mengikuti alur status pesanan live', () {
      final repository = OrderRepository();
      repository.addItem(createItem());
      final orderId = repository.checkout()!;

      final tracking = TrackingViewModel(
        repository: repository,
        orderId: orderId,
      );

      expect(tracking.isLiveOrder, isTrue);
      expect(tracking.status, 'Sedang Diproses');
      expect(tracking.nextStatus, 'Siap Diantar');

      tracking.advanceStatus();
      expect(tracking.status, 'Siap Diantar');
      expect(tracking.currentStepIndex, 1);

      tracking.advanceStatus();
      expect(tracking.status, 'Selesai');
      expect(tracking.canAdvance, isFalse);
    });

    test('tab Dalam Proses tetap memuat pesanan berstatus Siap Diantar', () {
      final repository = OrderRepository();
      final viewModel = OrderViewModel(repository);
      repository.addItem(createItem());
      final orderId = repository.checkout()!;

      repository.updateOrderStatus(orderId, 'Siap Diantar');

      expect(
        viewModel.visibleOrders.map((order) => order.id),
        contains(orderId),
      );
      expect(viewModel.processingCount, greaterThanOrEqualTo(1));
    });

    test('TrackingViewModel menandai mock history sebagai non-live', () {
      final repository = OrderRepository();
      final tracking = TrackingViewModel(
        repository: repository,
        orderId: 'WK-001',
      );

      expect(tracking.isOrderFound, isTrue);
      expect(tracking.isLiveOrder, isFalse);
      expect(tracking.canAdvance, isFalse);
    });

    test('checkout menyimpan catatan dapur, opsi item, dan subtotal', () {
      final repository = OrderRepository();
      repository.setKitchenNote('Tanpa sambal');
      repository.addItem(
        CartItem(
          menuName: 'Kopi Susu',
          menuImage: 'assets/images/kopi_susu.png',
          price: 18000,
          sugarLevel: 'Half (50%)',
          extraShot: true,
          temperature: 'Ice (Dingin)',
          quantity: 2,
          note: 'Es sedikit',
        ),
      );

      final orderId = repository.checkout()!;
      final order = repository.getOrderById(orderId)!;

      expect(order.id, 'WK-101');
      expect(order.note, 'Tanpa sambal');
      expect(order.price, 46000);
      expect(order.details, hasLength(1));
      expect(order.details.first['quantity'], 2);
      expect(order.details.first['subtotal'], 46000);
      expect(order.details.first['extraShot'], isTrue);
      expect(order.details.first['note'], 'Es sedikit');
      expect(repository.kitchenNote, isEmpty);
    });

    test('checkout QRIS menunggu pembayaran lalu ditandai lunas', () {
      final repository = OrderRepository();
      repository.setPaymentMethod('QRIS');
      repository.addItem(createItem());

      final orderId = repository.checkout()!;

      expect(
        repository.getOrderById(orderId)?.paymentStatus,
        'Menunggu Pembayaran',
      );
      expect(repository.markOrderPaid(orderId), isTrue);
      expect(repository.getOrderById(orderId)?.paymentStatus, 'Lunas');
      expect(repository.orders, hasLength(1));
      expect(repository.markOrderPaid('WK-TIDAK-ADA'), isFalse);
    });

    test('metode selain QRIS langsung lunas saat checkout', () {
      final repository = OrderRepository();
      repository.setPaymentMethod('Bayar Kasir (Cash / Tunai)');
      repository.addItem(createItem());

      final orderId = repository.checkout()!;

      expect(repository.getOrderById(orderId)?.paymentStatus, 'Lunas');
    });

    test('Take Away membersihkan meja dan Dine-in memulihkan meja default', () {
      final repository = OrderRepository();
      final viewModel = OrderViewModel(repository);

      viewModel.setOrderType('Dine-in (Makan di Tempat)');
      viewModel.setTableNumber('Meja 09');
      expect(viewModel.tableNumber, 'Meja 09');

      viewModel.setOrderType('Take Away (Bungkus)');
      expect(viewModel.orderType, 'Take Away');
      expect(viewModel.tableNumber, isEmpty);

      viewModel.setOrderType('Dine-in (Makan di Tempat)');
      expect(viewModel.orderType, 'Dine-in');
      expect(viewModel.tableNumber, 'Meja 05');
    });

    test('checkout kedua ditolak sehingga tidak ada pesanan duplikat', () {
      final repository = OrderRepository();
      repository.addItem(createItem());

      final firstId = repository.checkout();
      final secondId = repository.checkout();

      expect(firstId, 'WK-101');
      expect(secondId, isNull);
      expect(repository.orders, hasLength(1));
      expect(repository.cart, isEmpty);
    });

    test('tab riwayat menemukan pesanan selesai dan memisahkan yang diproses', () {
      final repository = OrderRepository();
      final viewModel = OrderViewModel(repository);
      repository.addItem(createItem());
      final orderId = repository.checkout()!;
      repository.updateOrderStatus(orderId, 'Selesai');

      viewModel.selectOrderTab(1);
      expect(
        viewModel.visibleOrders.map((order) => order.id),
        contains(orderId),
      );
      expect(viewModel.historyCount, 5);

      viewModel.selectOrderTab(0);
      expect(
        viewModel.visibleOrders.map((order) => order.id),
        isNot(contains(orderId)),
      );
      expect(
        viewModel.visibleOrders.map((order) => order.id),
        contains('WK-001'),
      );
      expect(viewModel.getOrderById(orderId)?.id, orderId);
      expect(viewModel.getOrderById('WK-011')?.status, 'Selesai');
    });
  });
}
