import 'package:flutter/material.dart';

class GoalsService {
  static Future<List<Goal>> getGoals() async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return [
      Goal(
        id: '1',
        title: 'Vacances d\'été',
        target: 2000.0,
        current: 1200.0,
        deadline: DateTime(2024, 6, 1),
        icon: Icons.beach_access,
        color: Colors.blue,
      ),
      Goal(
        id: '2',
        title: 'Nouveau PC',
        target: 1500.0,
        current: 750.0,
        deadline: DateTime(2024, 5, 15),
        icon: Icons.computer,
        color: Colors.purple,
      ),
      Goal(
        id: '3',
        title: 'Fonds d\'urgence',
        target: 5000.0,
        current: 3500.0,
        deadline: DateTime(2024, 12, 31),
        icon: Icons.savings,
        color: Colors.green,
      ),
    ];
  }

  static Future<bool> addGoal(Goal goal) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> updateGoal(Goal goal) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> deleteGoal(String goalId) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> addFunds(String goalId, double amount) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

class Goal {
  final String id;
  final String title;
  final double target;
  final double current;
  final DateTime deadline;
  final IconData icon;
  final Color color;

  Goal({
    required this.id,
    required this.title,
    required this.target,
    required this.current,
    required this.deadline,
    required this.icon,
    required this.color,
  });

  double get progress => current / target;
  bool get isCompleted => current >= target;
  int get daysLeft => deadline.difference(DateTime.now()).inDays;
  String get formattedDeadline =>
      '${deadline.day}/${deadline.month}/${deadline.year}';
}
