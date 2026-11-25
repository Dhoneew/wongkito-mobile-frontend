import 'package:flutter/foundation.dart';

import '../models/notification.dart';
import '../repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository repository;

  NotificationViewModel(this.repository);

  /// Status "dibaca" dipertahankan selama aplikasi berjalan.
  static final NotificationViewModel shared =
      NotificationViewModel(NotificationRepository());

  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((item) => !item.isRead).length;

  void loadNotifications() {
    _notifications = List<NotificationModel>.from(
      repository.getNotifications(),
    );
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index == -1 || _notifications[index].isRead) return;

    repository.markAsRead(id);
    _notifications[index] = _notifications[index].copyWith(isRead: true);
    notifyListeners();
  }

  void markAllAsRead() {
    if (unreadCount == 0) return;

    repository.markAllAsRead();
    _notifications = _notifications
        .map((item) => item.copyWith(isRead: true))
        .toList();
    notifyListeners();
  }

  void reset() {
    repository.reset();
    loadNotifications();
  }
}
