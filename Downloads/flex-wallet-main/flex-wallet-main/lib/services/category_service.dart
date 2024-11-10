import 'package:flutter/material.dart';

class CategoryService {
  static final List<Map<String, dynamic>> _categories = [
    {
      'id': '1',
      'name': 'Shopping',
      'icon': Icons.shopping_bag_outlined,
      'color': Colors.blue,
      'budget': 600.0,
      'spent': 450.0,
    },
    {
      'id': '2',
      'name': 'Restaurant',
      'icon': Icons.restaurant_outlined,
      'color': Colors.orange,
      'budget': 300.0,
      'spent': 280.0,
    },
    {
      'id': '3',
      'name': 'Transport',
      'icon': Icons.directions_car_outlined,
      'color': Colors.green,
      'budget': 200.0,
      'spent': 120.0,
    },
    {
      'id': '4',
      'name': 'Loisirs',
      'icon': Icons.sports_esports_outlined,
      'color': Colors.purple,
      'budget': 200.0,
      'spent': 150.0,
    },
  ];

  static Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _categories.map((data) => Category.fromMap(data)).toList();
  }

  static Future<Category> getCategoryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final data = _categories.firstWhere((cat) => cat['id'] == id);
    return Category.fromMap(data);
  }

  static Future<bool> addCategory(Category category) async {
    await Future.delayed(const Duration(seconds: 1));
    _categories.add(category.toMap());
    return true;
  }

  static Future<bool> updateCategory(Category category) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _categories.indexWhere((cat) => cat['id'] == category.id);
    if (index != -1) {
      _categories[index] = category.toMap();
      return true;
    }
    return false;
  }

  static Future<bool> deleteCategory(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    _categories.removeWhere((cat) => cat['id'] == id);
    return true;
  }

  static Future<Map<String, double>> getCategoryDistribution() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final categories = await getCategories();
    Map<String, double> distribution = {};
    double total = categories.fold(0.0, (sum, cat) => sum + cat.spent);

    for (var category in categories) {
      distribution[category.name] = category.spent / total;
    }
    return distribution;
  }

  static Future<double> getTotalSpent() async {
    final categories = await getCategories();
    return categories.fold<double>(0.0, (sum, cat) => sum + cat.spent);
  }

  static Future<double> getTotalBudget() async {
    final categories = await getCategories();
    return categories.fold<double>(0.0, (sum, cat) => sum + cat.budget);
  }
}

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final double budget;
  final double spent;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.budget,
    required this.spent,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      color: map['color'],
      budget: map['budget'],
      spent: map['spent'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'budget': budget,
      'spent': spent,
    };
  }

  double get progress => spent / budget;
  bool get isOverBudget => spent > budget;
  double get remaining => budget - spent;
  String get formattedSpent => '${spent.toStringAsFixed(2)} €';
  String get formattedBudget => '${budget.toStringAsFixed(2)} €';
  String get formattedRemaining => '${remaining.toStringAsFixed(2)} €';
  String get formattedProgress => '${(progress * 100).toStringAsFixed(1)}%';
}
