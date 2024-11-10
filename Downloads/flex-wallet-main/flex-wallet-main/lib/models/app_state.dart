import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // User data
  String? _phoneNumber;
  String? _userName;
  bool _isAuthenticated = false;
  bool _showBalance = true;

  // Financial data
  double _balance = 1234.56;
  double _income = 2500.00;
  double _expenses = 1265.44;

  // Settings
  bool _biometricEnabled = false;
  bool _notificationsEnabled = true;
  String _language = 'Français';
  ThemeMode _themeMode = ThemeMode.light;

  // Getters
  String? get phoneNumber => _phoneNumber;
  String? get userName => _userName;
  bool get isAuthenticated => _isAuthenticated;
  bool get showBalance => _showBalance;
  double get balance => _balance;
  double get income => _income;
  double get expenses => _expenses;
  bool get biometricEnabled => _biometricEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  ThemeMode get themeMode => _themeMode;

  // Methods
  void login(String phoneNumber) {
    _phoneNumber = phoneNumber;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _phoneNumber = null;
    _userName = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void toggleBalanceVisibility() {
    _showBalance = !_showBalance;
    notifyListeners();
  }

  void updateBalance(double amount) {
    _balance += amount;
    if (amount > 0) {
      _income += amount;
    } else {
      _expenses += amount.abs();
    }
    notifyListeners();
  }

  void toggleBiometric() {
    _biometricEnabled = !_biometricEnabled;
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  void setLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
