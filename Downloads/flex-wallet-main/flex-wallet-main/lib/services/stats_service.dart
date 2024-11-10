
class StatsService {
  static Future<Map<String, dynamic>> getMonthlyStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'income': 2500.00,
      'expenses': 1265.44,
      'savings': 1234.56,
      'investments': 3456.78,
      'incomeChange': 8.0,
      'expensesChange': 12.0,
      'savingsChange': 15.0,
      'investmentsChange': 5.0,
    };
  }

  static Future<List<DailyStats>> getWeeklyStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 6)),
        income: 0,
        expenses: 1200,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 5)),
        income: 0,
        expenses: 800,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 4)),
        income: 2500,
        expenses: 1500,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 3)),
        income: 0,
        expenses: 2000,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 2)),
        income: 0,
        expenses: 1800,
      ),
      DailyStats(
        date: DateTime.now().subtract(const Duration(days: 1)),
        income: 0,
        expenses: 2500,
      ),
      DailyStats(
        date: DateTime.now(),
        income: 0,
        expenses: 2200,
      ),
    ];
  }

  static Future<List<MonthlyStats>> getYearlyStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<MonthlyStats> stats = [];
    final now = DateTime.now();

    for (int i = 11; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      stats.add(
        MonthlyStats(
          date: date,
          income: 2500.0 + (100 * i),
          expenses: 1500.0 + (50 * i),
          savings: 1000.0 + (25 * i),
        ),
      );
    }
    return stats;
  }

  static Future<Map<String, List<double>>> getTrends() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'income': [2300, 2400, 2500, 2450, 2600, 2550, 2500],
      'expenses': [1100, 1300, 1200, 1400, 1250, 1300, 1265],
      'savings': [1200, 1100, 1300, 1050, 1350, 1250, 1235],
    };
  }

  static Future<Map<String, double>> getExpenseBreakdown() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'Shopping': 450.0,
      'Restaurant': 280.0,
      'Transport': 120.0,
      'Loisirs': 150.0,
      'Factures': 240.0,
      'Autres': 25.44,
    };
  }
}

class DailyStats {
  final DateTime date;
  final double income;
  final double expenses;

  DailyStats({
    required this.date,
    required this.income,
    required this.expenses,
  });

  double get total => income - expenses;
  String get formattedDate => '${date.day}/${date.month}';
  String get formattedTotal => '${total.toStringAsFixed(2)} €';
}

class MonthlyStats {
  final DateTime date;
  final double income;
  final double expenses;
  final double savings;

  MonthlyStats({
    required this.date,
    required this.income,
    required this.expenses,
    required this.savings,
  });

  double get total => income - expenses;
  String get formattedMonth => '${date.month}/${date.year}';
  String get formattedTotal => '${total.toStringAsFixed(2)} €';
  double get savingsRate => savings / income * 100;
}
