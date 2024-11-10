import 'package:flutter/material.dart';
import '../widgets/custom_snackbar.dart';

class BillsPage extends StatelessWidget {
  final List<Map<String, dynamic>> bills = [
    {
      'title': 'Électricité',
      'provider': 'EDF',
      'amount': '89.99 €',
      'dueDate': '25 Mars 2024',
      'status': 'À payer',
      'icon': Icons.bolt,
      'color': Colors.orange,
    },
    {
      'title': 'Internet',
      'provider': 'Orange',
      'amount': '39.99 €',
      'dueDate': '28 Mars 2024',
      'status': 'À payer',
      'icon': Icons.wifi,
      'color': Colors.blue,
    },
    {
      'title': 'Eau',
      'provider': 'Veolia',
      'amount': '45.50 €',
      'dueDate': '20 Mars 2024',
      'status': 'Payée',
      'icon': Icons.water_drop,
      'color': Colors.lightBlue,
    },
    {
      'title': 'Assurance',
      'provider': 'AXA',
      'amount': '65.00 €',
      'dueDate': '15 Mars 2024',
      'status': 'Payée',
      'icon': Icons.security,
      'color': Colors.green,
    },
  ];

  const BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factures'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildSummary(context),
          Expanded(
            child: _buildBillsList(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CustomSnackbar.show(
            context: context,
            message: 'Ajout de facture à venir',
          );
        },
        tooltip: 'Ajouter une facture',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final unpaidBills =
        bills.where((bill) => bill['status'] == 'À payer').length;
    final totalAmount = bills.where((bill) => bill['status'] == 'À payer').fold(
        0.0, (sum, bill) => sum + double.parse(bill['amount'].split(' ')[0]));

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Factures à payer',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$unpaidBills factures',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Montant total',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${totalAmount.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                CustomSnackbar.show(
                  context: context,
                  message: 'Paiement groupé à venir',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text('Tout payer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: ListView.builder(
        itemCount: bills.length,
        itemBuilder: (context, index) {
          final bill = bills[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bill['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  bill['icon'],
                  color: bill['color'],
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bill['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    bill['amount'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: bill['status'] == 'À payer'
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(bill['provider']),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Échéance : ${bill['dueDate']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: bill['status'] == 'À payer'
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          bill['status'],
                          style: TextStyle(
                            color: bill['status'] == 'À payer'
                                ? Colors.orange
                                : Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                CustomSnackbar.show(
                  context: context,
                  message: 'Détails de la facture à venir',
                );
              },
            ),
          );
        },
      ),
    );
  }
}
