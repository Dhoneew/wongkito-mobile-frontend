import 'package:flutter/material.dart';

import '../../features/notification/models/notification.dart';
import '../../features/notification/viewmodels/notification_viewmodel.dart';
import '../../theme/wkm_style.dart';
import '../../main.dart';

class NotificationScreen extends StatefulWidget {
  /// Diberikan oleh tab induk supaya tap notifikasi bisa mengganti tab tanpa
  /// membuat MainNavigation baru dan mereset state halaman lain.
  final ValueChanged<int>? onNavigateTab;

  const NotificationScreen({super.key, this.onNavigateTab});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = NotificationViewModel.shared;
    viewModel.loadNotifications();
    viewModel.addListener(_onNotificationsChanged);
  }

  void _onNotificationsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    viewModel.removeListener(_onNotificationsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = viewModel.unreadCount;

    return Scaffold(
      backgroundColor: WkmColors.background,
      appBar: AppBar(
        backgroundColor: WkmColors.background,
        foregroundColor: WkmColors.dark,
        elevation: 0,
        leading: wkmBackButton(() => Navigator.pop(context)),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Tandai semua dibaca',
            onPressed: unreadCount == 0 ? null : _markAllAsRead,
            icon: const Icon(Icons.done_all, color: WkmColors.orange),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '$unreadCount notifikasi belum dibaca',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: WkmColors.muted,
                ),
              ),
            ),
          if (viewModel.notifications.isEmpty)
            _buildEmptyState()
          else
            ...viewModel.notifications.map(_buildNotificationItem),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: WkmColors.softOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 40,
              color: WkmColors.orange,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada notifikasi',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: WkmColors.dark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Info pesanan dan promo akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: WkmColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: wkmCardDecoration(radius: 12).copyWith(
        color: notification.isPromo ? WkmColors.dangerSoft : Colors.white,
        border: Border.all(
          color: WkmColors.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleNotificationTap(notification),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: notification.iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: notification.isRead
                              ? FontWeight.w500
                              : FontWeight.bold,
                          color: WkmColors.dark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        notification.subtitle,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: WkmColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: WkmColors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _markAllAsRead() {
    viewModel.markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi ditandai sebagai dibaca.'),
        backgroundColor: WkmColors.success,
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    final wasRead = notification.isRead;
    viewModel.markAsRead(notification.id);

    final target = notification.target;
    if (target == 'orders' || target == 'menu') {
      final index = target == 'orders' ? 2 : 1;
      if (widget.onNavigateTab != null) {
        if (context.mounted) Navigator.pop(context);
        widget.onNavigateTab!(index);
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigation(initialIndex: index),
        ),
        (route) => false,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasRead
              ? 'Notifikasi ini sudah dibaca.'
              : 'Notifikasi ditandai sebagai dibaca.',
        ),
        backgroundColor: WkmColors.success,
      ),
    );
  }
}
