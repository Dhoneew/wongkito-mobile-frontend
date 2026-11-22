import 'package:flutter/foundation.dart';

import '../models/notification.dart';
import '../repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository repository;

  NotificationViewModel(this.repository);

  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  void loadNotifications() {
    _notifications = repository.getNotifications();
    notifyListeners();
  }
}
