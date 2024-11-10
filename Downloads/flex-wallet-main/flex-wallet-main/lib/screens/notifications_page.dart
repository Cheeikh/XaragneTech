import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Transfert reçu',
      'message': 'Vous avez reçu 50€ de Marie Dupont',
      'time': 'Il y a 5 minutes',
      'icon': Icons.arrow_downward,
      'color': Colors.green,
      'isRead': false,
    },
    {
      'title': 'Paiement effectué',
      'message': 'Paiement de 32.50€ chez Restaurant Le Gourmet',
      'time': 'Il y a 2 heures',
      'icon': Icons.payment,
      'color': Colors.blue,
      'isRead': false,
    },
    {
      'title': 'Nouveau service disponible',
      'message': 'Découvrez notre nouveau service d\'épargne automatique',
      'time': 'Hier',
      'icon': Icons.new_releases,
      'color': Colors.orange,
      'isRead': true,
    },
    {
      'title': 'Transfert envoyé',
      'message': 'Transfert de 25€ à Pierre Martin effectué avec succès',
      'time': 'Hier',
      'icon': Icons.arrow_upward,
      'color': Colors.red,
      'isRead': true,
    },
    {
      'title': 'Promotion',
      'message': 'Invitez vos amis et gagnez 10€ par parrainage',
      'time': 'Il y a 2 jours',
      'icon': Icons.card_giftcard,
      'color': Colors.purple,
      'isRead': true,
    },
  ];

  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              CustomSnackbar.show(
                context: context,
                message: 'Toutes les notifications ont été marquées comme lues',
              );
            },
            child: const Text('Tout marquer comme lu'),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationItem(context, notification);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vous n\'avez pas de nouvelles notifications',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context, Map<String, dynamic> notification) {
    return Dismissible(
      key: Key(notification['title']),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        CustomSnackbar.show(
          context: context,
          message: 'Notification supprimée',
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification['isRead'] ? null : Colors.blue.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: notification['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification['icon'],
              color: notification['color'],
            ),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontWeight:
                  notification['isRead'] ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification['message']),
              const SizedBox(height: 4),
              Text(
                notification['time'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          onTap: () {
            CustomSnackbar.show(
              context: context,
              message: 'Détails de la notification à venir',
            );
          },
        ),
      ),
    );
  }
}
