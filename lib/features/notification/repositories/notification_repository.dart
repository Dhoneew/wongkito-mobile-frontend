import 'package:flutter/material.dart';

import '../models/notification.dart';

class NotificationRepository {
  List<NotificationModel> getNotifications() {
    return const [
      NotificationModel(
        icon: Icons.takeout_dining,
        iconBgColor: Color(0xFFFFE8C5),
        iconColor: Color(0xFFF57C00),
        title: 'Pesanan siap diambil',
        subtitle: 'Pesanan sudah selesai dibuat',
      ),
      NotificationModel(
        icon: Icons.takeout_dining,
        iconBgColor: Color(0xFFFFE8C5),
        iconColor: Color(0xFFF57C00),
        title: 'Pesanan sedang dibuat',
        subtitle: 'Barista sedang menyiapkan pesanan',
      ),
      NotificationModel(
        icon: Icons.local_offer,
        iconBgColor: Color(0xFFFFD6D6),
        iconColor: Color(0xFFF57C00),
        title: 'Promo paket kenyang hemat',
        subtitle: 'Dapatkan diskon spesial hari ini',
        isPromo: true,
      ),
    ];
  }
}
