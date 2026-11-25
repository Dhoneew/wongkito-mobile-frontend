import 'package:flutter/material.dart';

import '../../../theme/wkm_style.dart';
import '../models/notification.dart';

class NotificationRepository {
  static List<NotificationModel> _defaultNotifications() => [
    const NotificationModel(
      id: 'order-ready',
      icon: Icons.takeout_dining,
      iconBgColor: WkmColors.softOrange,
      iconColor: WkmColors.orange,
      title: 'Pesanan siap diambil',
      subtitle: 'Pesanan sudah selesai dibuat',
      target: 'orders',
    ),
    const NotificationModel(
      id: 'order-processing',
      icon: Icons.takeout_dining,
      iconBgColor: WkmColors.softOrange,
      iconColor: WkmColors.orange,
      title: 'Pesanan sedang dibuat',
      subtitle: 'Barista sedang menyiapkan pesanan',
      target: 'orders',
    ),
    const NotificationModel(
      id: 'promo-package',
      icon: Icons.local_offer,
      iconBgColor: WkmColors.dangerSoft,
      iconColor: WkmColors.orange,
      title: 'Promo paket hemat kenyang',
      subtitle: 'Dapatkan diskon spesial hari ini',
      isPromo: true,
      target: 'menu',
    ),
  ];

  List<NotificationModel> _notifications = _defaultNotifications();

  List<NotificationModel> getNotifications() {
    return List.unmodifiable(_notifications);
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index == -1 || _notifications[index].isRead) return;
    _notifications[index] = _notifications[index].copyWith(isRead: true);
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  /// Kembalikan status baca demo ke kondisi awal saat user logout.
  void reset() {
    _notifications = _defaultNotifications();
  }
}
