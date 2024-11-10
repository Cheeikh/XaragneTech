import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _biometricKey = 'biometric_enabled';
  static const String _showBalanceKey = 'show_balance';
  static const String _currencyKey = 'currency';

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Theme
  ThemeMode getThemeMode() {
    final value = _prefs.getString(_themeKey) ?? 'system';
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }
    await _prefs.setString(_themeKey, value);
  }

  // Language
  String getLanguage() {
    return _prefs.getString(_languageKey) ?? 'fr';
  }

  Future<void> setLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }

  // Notifications
  bool getNotificationsEnabled() {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }

  // Biometric
  bool getBiometricEnabled() {
    return _prefs.getBool(_biometricKey) ?? false;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _prefs.setBool(_biometricKey, enabled);
  }

  // Show Balance
  bool getShowBalance() {
    return _prefs.getBool(_showBalanceKey) ?? true;
  }

  Future<void> setShowBalance(bool show) async {
    await _prefs.setBool(_showBalanceKey, show);
  }

  // Currency
  String getCurrency() {
    return _prefs.getString(_currencyKey) ?? 'EUR';
  }

  Future<void> setCurrency(String currency) async {
    await _prefs.setString(_currencyKey, currency);
  }

  // Clear all preferences
  Future<void> clear() async {
    await _prefs.clear();
  }

  // Get all preferences as Map
  Map<String, dynamic> getAllPreferences() {
    return {
      'theme': getThemeMode().toString(),
      'language': getLanguage(),
      'notifications': getNotificationsEnabled(),
      'biometric': getBiometricEnabled(),
      'showBalance': getShowBalance(),
      'currency': getCurrency(),
    };
  }
}
