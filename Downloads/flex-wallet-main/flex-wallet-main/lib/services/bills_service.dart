import 'package:flutter/material.dart';

class BillsService {
  static Future<List<Bill>> getBills() async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return [
      Bill(
        id: '1',
        title: 'Électricité',
        provider: 'EDF',
        amount: 89.99,
        dueDate: DateTime(2024, 3, 25),
        status: BillStatus.pending,
        icon: Icons.bolt,
        color: Colors.orange,
      ),
      Bill(
        id: '2',
        title: 'Internet',
        provider: 'Orange',
        amount: 39.99,
        dueDate: DateTime(2024, 3, 28),
        status: BillStatus.pending,
        icon: Icons.wifi,
        color: Colors.blue,
      ),
      Bill(
        id: '3',
        title: 'Eau',
        provider: 'Veolia',
        amount: 45.50,
        dueDate: DateTime(2024, 3, 20),
        status: BillStatus.paid,
        icon: Icons.water_drop,
        color: Colors.lightBlue,
      ),
    ];
  }

  static Future<bool> addBill(Bill bill) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> payBill(String billId) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> payMultipleBills(List<String> billIds) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<bool> deleteBill(String billId) async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  static Future<List<Bill>> getUpcomingBills() async {
    // Simuler une requête API
    await Future.delayed(const Duration(seconds: 1));
    final bills = await getBills();
    return bills.where((bill) => bill.status == BillStatus.pending).toList();
  }

  static Future<double> getTotalPendingAmount() async {
    final bills = await getUpcomingBills();
    return bills.fold<double>(0.0, (sum, bill) => sum + bill.amount);
  }
}

enum BillStatus { pending, paid, overdue }

class Bill {
  final String id;
  final String title;
  final String provider;
  final double amount;
  final DateTime dueDate;
  final BillStatus status;
  final IconData icon;
  final Color color;

  Bill({
    required this.id,
    required this.title,
    required this.provider,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.icon,
    required this.color,
  });

  bool get isOverdue =>
      status == BillStatus.pending && dueDate.isBefore(DateTime.now());
  String get formattedAmount => '${amount.toStringAsFixed(2)} €';
  String get formattedDueDate =>
      '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  String get statusText => status == BillStatus.pending ? 'À payer' : 'Payée';
}
