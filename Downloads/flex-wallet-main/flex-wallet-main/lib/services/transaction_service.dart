
class TransactionService {
  static Future<bool> sendMoney({
    required String recipient,
    required double amount,
    String? note,
  }) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> requestMoney({
    required String from,
    required double amount,
    String? note,
  }) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<List<Transaction>> getRecentTransactions() async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return [
      Transaction(
        id: '1',
        title: 'Achat Carrefour',
        amount: -45.99,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'Shopping',
        type: TransactionType.expense,
      ),
      Transaction(
        id: '2',
        title: 'Salaire',
        amount: 2500.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Revenu',
        type: TransactionType.income,
      ),
      // ... autres transactions
    ];
  }
}

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;
  final String? note;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.note,
  });
}
