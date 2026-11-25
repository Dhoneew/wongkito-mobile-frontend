import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../repositories/order_repository.dart';

class TrackingViewModel extends ChangeNotifier {
  static const String statusProcessing = 'Sedang Diproses';
  static const String statusReady = 'Siap Diantar';
  static const String statusCompleted = 'Selesai';

  static const List<String> statusFlow = [
    statusProcessing,
    statusReady,
    statusCompleted,
  ];

  final OrderRepository repository;
  final String orderId;

  TrackingViewModel({required this.repository, required this.orderId});

  Order? get order {
    try {
      return repository.allOrders.firstWhere((item) => item.id == orderId);
    } catch (_) {
      return null;
    }
  }

  /// Hanya pesanan yang dibuat dalam sesi ini yang bisa disimulasikan.
  bool get isLiveOrder =>
      repository.orders.any((item) => item.id == orderId);

  String get status => order?.status ?? 'Pesanan Tidak Ditemukan';

  bool get isProcessing => status == statusProcessing;

  bool get isCompleted => status == statusCompleted;

  bool get isReady => status == statusReady;

  bool get isOrderFound => order != null;

  int get currentStepIndex {
    final index = statusFlow.indexOf(status);
    return index == -1 ? 0 : index;
  }

  String? get nextStatus {
    if (!isLiveOrder) return null;
    final index = statusFlow.indexOf(status);
    if (index == -1 || index >= statusFlow.length - 1) return null;
    return statusFlow[index + 1];
  }

  bool get canAdvance => nextStatus != null;

  int get total => order?.price ?? 0;

  String get items => order?.items ?? '';

  String get orderType => order?.orderType ?? '';

  String get tableNumber => order?.tableNumber ?? '';

  String get paymentMethod => order?.paymentMethod ?? '';

  String get paymentStatus => order?.paymentStatus ?? '';

  String get note => order?.note ?? '';

  List<Map<String, dynamic>> get details => order?.details ?? const [];

  void updateStatus(String newStatus) {
    repository.updateOrderStatus(orderId, newStatus);
    notifyListeners();
  }

  /// Melangkah ke status berikutnya dalam alur simulasi.
  void advanceStatus() {
    final next = nextStatus;
    if (next != null) updateStatus(next);
  }

  void refresh() {
    notifyListeners();
  }
}
