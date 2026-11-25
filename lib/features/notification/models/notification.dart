import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isPromo;
  final bool isRead;

  /// Tujuan opsional: 'orders', 'menu', atau null bila tidak ada halaman tujuan.
  final String? target;

  const NotificationModel({
    required this.id,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.isPromo = false,
    this.isRead = false,
    this.target,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      icon: icon,
      iconBgColor: iconBgColor,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      isPromo: isPromo,
      isRead: isRead ?? this.isRead,
      target: target,
    );
  }
}
