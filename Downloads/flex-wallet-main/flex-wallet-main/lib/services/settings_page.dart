import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  late SharedPreferences _prefs;

  // Clés pour les préférences
  static const String _pinKey = 'pin_code';
  static const String _biometricKey = 'biometric_enabled';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _smsAuthKey = 'sms_auth_enabled';
  static const String _newDeviceNotifKey = 'new_device_notifications';
  static const String _autoLockKey = 'auto_lock_timeout';
  static const String _lastBackupKey = 'last_backup_date';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // PIN
  Future<bool> verifyPin(String pin) async {
    final storedPin = _prefs.getString(_pinKey);
    return storedPin == pin;
  }

  Future<void> setPin(String pin) async {
    await _prefs.setString(_pinKey, pin);
  }

  Future<bool> hasPin() async {
    return _prefs.containsKey(_pinKey);
  }

  // Biométrie
  Future<void> setBiometricEnabled(bool enabled) async {
    await _prefs.setBool(_biometricKey, enabled);
  }

  bool getBiometricEnabled() {
    return _prefs.getBool(_biometricKey) ?? false;
  }

  // Notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  // Authentification SMS
  Future<void> setSmsAuthEnabled(bool enabled) async {
    await _prefs.setBool(_smsAuthKey, enabled);
  }

  bool getSmsAuthEnabled() {
    return _prefs.getBool(_smsAuthKey) ?? true;
  }

  // Notifications nouvel appareil
  Future<void> setNewDeviceNotifications(bool enabled) async {
    await _prefs.setBool(_newDeviceNotifKey, enabled);
  }

  bool getNewDeviceNotifications() {
    return _prefs.getBool(_newDeviceNotifKey) ?? true;
  }

  // Verrouillage automatique
  Future<void> setAutoLockTimeout(int minutes) async {
    await _prefs.setInt(_autoLockKey, minutes);
  }

  int getAutoLockTimeout() {
    return _prefs.getInt(_autoLockKey) ?? 5; // 5 minutes par défaut
  }

  // Sauvegarde
  Future<void> setLastBackupDate(DateTime date) async {
    await _prefs.setString(_lastBackupKey, date.toIso8601String());
  }

  DateTime? getLastBackupDate() {
    final dateStr = _prefs.getString(_lastBackupKey);
    return dateStr != null ? DateTime.parse(dateStr) : null;
  }

  // Exporter les données
  Future<Map<String, dynamic>> exportData() async {
    return {
      'biometric_enabled': getBiometricEnabled(),
      'notifications_enabled': getNotificationsEnabled(),
      'sms_auth_enabled': getSmsAuthEnabled(),
      'new_device_notifications': getNewDeviceNotifications(),
      'auto_lock_timeout': getAutoLockTimeout(),
      'last_backup': getLastBackupDate()?.toIso8601String(),
    };
  }

  // Réinitialiser les paramètres
  Future<void> resetSettings() async {
    await _prefs.clear();
  }
}
