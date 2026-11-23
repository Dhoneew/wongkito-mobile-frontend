import 'package:flutter/material.dart';

class NotificationModel {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isPromo;

  const NotificationModel({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.isPromo = false,
  });
}
