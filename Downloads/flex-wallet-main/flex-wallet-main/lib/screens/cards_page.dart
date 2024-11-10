import 'package:flutter/material.dart';
import '../widgets/card_widget.dart';
import '../widgets/custom_snackbar.dart';

class CardsPage extends StatelessWidget {
  final List<Map<String, dynamic>> cards = [
    {
      'number': '**** **** **** 1234',
      'holder': 'JOHN DOE',
      'expiry': '12/25',
      'type': 'VISA',
      'color': const Color(0xFF1E88E5),
    },
    {
      'number': '**** **** **** 5678',
      'holder': 'JOHN DOE',
      'expiry': '09/24',
      'type': 'MASTERCARD',
      'color': const Color(0xFF43A047),
    },
  ];

  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes cartes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Cartes disponibles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...cards.map((card) => CardWidget(
                  cardNumber: card['number'],
                  cardHolder: card['holder'],
                  expiryDate: card['expiry'],
                  cardType: card['type'],
                  color: card['color'],
                  onTap: () {
                    CustomSnackbar.show(
                      context: context,
                      message: 'Détails de la carte à venir',
                    );
                  },
                )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  CustomSnackbar.show(
                    context: context,
                    message: 'Ajout de carte à venir',
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Ajouter une carte'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
