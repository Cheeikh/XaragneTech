import 'package:flutter/material.dart';
import '../widgets/stats_chart.dart';
import '../widgets/stats_detail.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
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
                'Aperçu mensuel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StatsChart(
              data: const [1200, 800, 1500, 2000, 1800, 2500, 2200],
              labels: const ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
              color: Theme.of(context).primaryColor,
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Résumé',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: StatsDetail(
                          title: 'Dépenses',
                          amount: '1,265.44 €',
                          percentage: '12%',
                          icon: Icons.arrow_downward,
                          color: Colors.red,
                          isIncrease: false,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: StatsDetail(
                          title: 'Revenus',
                          amount: '2,500.00 €',
                          percentage: '8%',
                          icon: Icons.arrow_upward,
                          color: Colors.green,
                          isIncrease: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StatsDetail(
                          title: 'Épargne',
                          amount: '1,234.56 €',
                          percentage: '15%',
                          icon: Icons.savings_outlined,
                          color: Colors.blue,
                          isIncrease: true,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: StatsDetail(
                          title: 'Investissements',
                          amount: '3,456.78 €',
                          percentage: '5%',
                          icon: Icons.trending_up,
                          color: Colors.purple,
                          isIncrease: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
