import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';

class TransactionDetailsPage extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailsPage({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la transaction'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildDetails(context),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: transaction.isExpense
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction.icon,
              size: 40,
              color: transaction.isExpense ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            transaction.amount,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: transaction.isExpense ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            transaction.title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
          Text(
            transaction.date,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Détails de la transaction',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Type', transaction.isExpense ? 'Dépense' : 'Revenu'),
          _buildDetailRow('Catégorie', 'Shopping'),
          _buildDetailRow('Mode de paiement', 'Carte Visa'),
          _buildDetailRow('Statut', 'Terminé'),
          _buildDetailRow(
              'ID Transaction', '#TRX${DateTime.now().millisecondsSinceEpoch}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              CustomSnackbar.show(
                context: context,
                message: 'Reçu téléchargé',
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Télécharger le reçu'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              CustomSnackbar.show(
                context: context,
                message: 'Signalement envoyé',
              );
            },
            icon: const Icon(Icons.flag_outlined),
            label: const Text('Signaler un problème'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}

class Transaction {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final bool isExpense;

  Transaction({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.isExpense,
  });
}
