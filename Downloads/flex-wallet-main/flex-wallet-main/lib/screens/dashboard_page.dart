import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_list.dart';
import '../widgets/action_button.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/stats_chart.dart';
import 'notifications_page.dart';
import 'profile_page.dart';
import 'transfer_page.dart';
import 'cards_page.dart';
import 'bills_page.dart';
import 'stats_page.dart';
import 'reports_page.dart';
import 'financial_goals_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  bool _showBalance = true;

  final List<Transaction> recentTransactions = [
    Transaction(
      icon: Icons.shopping_bag_outlined,
      title: 'Achat Carrefour',
      date: '15 Mars 2024',
      amount: '-45.99 €',
      isExpense: true,
    ),
    Transaction(
      icon: Icons.attach_money,
      title: 'Salaire',
      date: '14 Mars 2024',
      amount: '+2,500.00 €',
      isExpense: false,
    ),
    Transaction(
      icon: Icons.fastfood_outlined,
      title: 'Restaurant',
      date: '14 Mars 2024',
      amount: '-32.50 €',
      isExpense: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          CustomSnackbar.show(
            context: context,
            message: 'Données mises à jour',
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCard(
                balance: _showBalance ? '1,234.56 €' : '••••••• €',
                income: _showBalance ? '+2,500.00 €' : '••••••• €',
                expenses: _showBalance ? '-1,265.44 €' : '••••••• €',
                onToggleVisibility: () {
                  setState(() => _showBalance = !_showBalance);
                },
              ),
              _buildQuickActions(context),
              _buildGoals(context),
              _buildStatsSummary(context),
              TransactionList(
                transactions: recentTransactions,
                onViewAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportsPage()),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TransferPage()),
        ),
        elevation: 2,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildGoals(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Objectifs d\'épargne',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FinancialGoalsPage()),
                  ),
                  child: const Text('Voir tout'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildGoalCard(
                  context,
                  'Vacances d\'été',
                  2000.0,
                  1200.0,
                  Icons.beach_access,
                  Colors.blue,
                ),
                _buildGoalCard(
                  context,
                  'Nouveau PC',
                  1500.0,
                  750.0,
                  Icons.computer,
                  Colors.purple,
                ),
                _buildGoalCard(
                  context,
                  'Fonds d\'urgence',
                  5000.0,
                  3500.0,
                  Icons.savings,
                  Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context,
    String title,
    double target,
    double current,
    IconData icon,
    Color color,
  ) {
    final progress = current / target;
    final percentage = (progress * 100).toStringAsFixed(0);

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${current.toStringAsFixed(0)} € / ${target.toStringAsFixed(0)} €',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$percentage%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'FlexWallet',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          ),
        ),
        IconButton(
          icon: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.person_outline,
              size: 20,
              color: Colors.grey[800],
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions rapides',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionButton(
                icon: Icons.send,
                label: 'Envoyer',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransferPage()),
                ),
              ),
              ActionButton(
                icon: Icons.receipt_long,
                label: 'Factures',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BillsPage()),
                ),
              ),
              ActionButton(
                icon: Icons.credit_card,
                label: 'Cartes',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CardsPage()),
                ),
              ),
              ActionButton(
                icon: Icons.analytics_outlined,
                label: 'Stats',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aperçu des dépenses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                icon: Icons.shopping_bag_outlined,
                label: 'Shopping',
                amount: '450 €',
                color: Colors.blue,
              ),
              _buildStatItem(
                context,
                icon: Icons.fastfood_outlined,
                label: 'Restaurant',
                amount: '280 €',
                color: Colors.orange,
              ),
              _buildStatItem(
                context,
                icon: Icons.directions_car_outlined,
                label: 'Transport',
                amount: '120 €',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String amount,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        switch (index) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransferPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CardsPage()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz),
          activeIcon: Icon(Icons.swap_horiz),
          label: 'Transferts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          activeIcon: Icon(Icons.account_balance_wallet),
          label: 'Cartes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
    );
  }
}
