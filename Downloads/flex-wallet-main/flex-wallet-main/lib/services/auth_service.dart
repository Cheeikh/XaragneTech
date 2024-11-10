
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _phoneNumber;
  String? _userName;
  bool _isAuthenticated = false;
  bool _biometricEnabled = false;

  // Getters
  String? get phoneNumber => _phoneNumber;
  String? get userName => _userName;
  bool get isAuthenticated => _isAuthenticated;
  bool get biometricEnabled => _biometricEnabled;

  Future<bool> sendOtp(String phoneNumber) async {
    // Simuler l'envoi d'un OTP
    await Future.delayed(const Duration(seconds: 1));
    _phoneNumber = phoneNumber;
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    // Simuler la vérification d'un OTP
    await Future.delayed(const Duration(seconds: 1));
    return otp == '123456';
  }

  Future<bool> createPin(String pin) async {
    // Simuler la création d'un PIN
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> verifyPin(String pin) async {
    // Simuler la vérification d'un PIN
    await Future.delayed(const Duration(seconds: 1));
    if (pin == '1234') {
      _isAuthenticated = true;
      return true;
    }
    return false;
  }

  Future<bool> completeRegistration({
    required String firstName,
    required String lastName,
    String? email,
  }) async {
    // Simuler l'enregistrement des détails
    await Future.delayed(const Duration(seconds: 1));
    _userName = '$firstName $lastName';
    _isAuthenticated = true;
    return true;
  }

  Future<bool> toggleBiometric() async {
    // Simuler l'activation/désactivation de la biométrie
    await Future.delayed(const Duration(milliseconds: 500));
    _biometricEnabled = !_biometricEnabled;
    return true;
  }

  Future<bool> logout() async {
    // Simuler la déconnexion
    await Future.delayed(const Duration(milliseconds: 500));
    _phoneNumber = null;
    _userName = null;
    _isAuthenticated = false;
    return true;
  }

  Future<bool> deleteAccount() async {
    // Simuler la suppression du compte
    await Future.delayed(const Duration(seconds: 1));
    _phoneNumber = null;
    _userName = null;
    _isAuthenticated = false;
    return true;
  }
}
