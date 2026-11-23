import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../repositories/order_repository.dart';

class TrackingViewModel extends ChangeNotifier {
  final OrderRepository repository;
  final String orderId;

  TrackingViewModel({required this.repository, required this.orderId});

  Order? get order {
    try {
      return repository.orders.firstWhere((item) => item.id == orderId);
    } catch (_) {
      return null;
    }
  }

  String get status => order?.status ?? 'Pesanan Tidak Ditemukan';

  bool get isProcessing => status == 'Sedang Diproses';

  bool get isCompleted => status == 'Selesai';

  bool get isReady => status == 'Siap Diantar';

  bool get isOrderFound => order != null;

  int get total => order?.price ?? 0;

  String get orderType => order?.orderType ?? '';

  String get tableNumber => order?.tableNumber ?? '';

  String get paymentMethod => order?.paymentMethod ?? '';

  void updateStatus(String newStatus) {
    repository.updateOrderStatus(orderId, newStatus);
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
