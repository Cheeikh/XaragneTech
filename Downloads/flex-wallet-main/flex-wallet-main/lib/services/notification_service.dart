import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _notificationsEnabled = true;
  final List<Notification> _notifications = [];

  bool get notificationsEnabled => _notificationsEnabled;
  List<Notification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> initialize() async {
    // Simuler l'initialisation des notifications
    await Future.delayed(const Duration(milliseconds: 500));
    _loadInitialNotifications();
  }

  void _loadInitialNotifications() {
    _notifications.addAll([
      Notification(
        id: '1',
        title: 'Transfert reçu',
        message: 'Vous avez reçu 50€ de Marie Dupont',
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.transfer,
        isRead: false,
      ),
      Notification(
        id: '2',
        title: 'Paiement effectué',
        message: 'Paiement de 32.50€ chez Restaurant Le Gourmet',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.payment,
        isRead: false,
      ),
      Notification(
        id: '3',
        title: 'Nouveau service disponible',
        message: 'Découvrez notre nouveau service d\'épargne automatique',
        time: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.info,
        isRead: true,
      ),
    ]);
  }

  Future<bool> toggleNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _notificationsEnabled = !_notificationsEnabled;
    return _notificationsEnabled;
  }

  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  Future<void> deleteAllNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _notifications.clear();
  }

  Future<void> sendNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) async {
    if (!_notificationsEnabled) return;

    await Future.delayed(const Duration(milliseconds: 300));
    final notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      time: DateTime.now(),
      type: type,
      isRead: false,
    );
    _notifications.insert(0, notification);
  }
}

enum NotificationType {
  transfer,
  payment,
  info,
  security,
  promotion,
}

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  final bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.transfer:
        return Icons.swap_horiz;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.transfer:
        return Colors.blue;
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.info:
        return Colors.orange;
      case NotificationType.security:
        return Colors.red;
      case NotificationType.promotion:
        return Colors.purple;
    }
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} heures';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? time,
    NotificationType? type,
    bool? isRead,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}
