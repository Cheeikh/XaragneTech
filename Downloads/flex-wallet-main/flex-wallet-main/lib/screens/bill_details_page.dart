import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';

class BillDetailsPage extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillDetailsPage({
    Key? key,
    required this.bill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la facture'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsDialog(context),
          ),
        ],
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bill['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              bill['icon'],
              size: 40,
              color: bill['color'],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            bill['amount'],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  (bill['status'] == 'À payer' ? Colors.orange : Colors.green)
                      .withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              bill['status'],
              style: TextStyle(
                color:
                    bill['status'] == 'À payer' ? Colors.orange : Colors.green,
                fontWeight: FontWeight.bold,
              ),
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
            'Informations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Fournisseur', bill['provider']),
          _buildDetailRow('Service', bill['title']),
          _buildDetailRow('Échéance', bill['dueDate']),
          _buildDetailRow('Numéro client', 'CLI123456789'),
          _buildDetailRow(
              'Référence', 'FAC${DateTime.now().millisecondsSinceEpoch}'),
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
          if (bill['status'] == 'À payer')
            ElevatedButton.icon(
              onPressed: () {
                CustomSnackbar.show(
                  context: context,
                  message: 'Paiement à venir',
                );
              },
              icon: const Icon(Icons.payment),
              label: const Text('Payer maintenant'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              CustomSnackbar.show(
                context: context,
                message: 'Téléchargement de la facture à venir',
              );
            },
            icon: const Icon(Icons.download_outlined),
            label: const Text('Télécharger la facture'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Partager'),
              onTap: () {
                Navigator.pop(context);
                CustomSnackbar.show(
                  context: context,
                  message: 'Partage à venir',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historique des paiements'),
              onTap: () {
                Navigator.pop(context);
                CustomSnackbar.show(
                  context: context,
                  message: 'Historique à venir',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_outlined),
              title: const Text('Contacter le support'),
              onTap: () {
                Navigator.pop(context);
                CustomSnackbar.show(
                  context: context,
                  message: 'Support à venir',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
