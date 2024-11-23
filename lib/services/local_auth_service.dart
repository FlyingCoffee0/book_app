import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Biyometrik doğrulama yapılabilir mi?
  Future<bool> canCheckBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }

  // Biyometrik doğrulama yap
  Future<bool> authenticateWithBiometrics() async {
    try {
      
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to proceed.',
        options: const AuthenticationOptions(
          stickyAuth: true, 
        ),
      );
      return isAuthenticated;
    } catch (e) {
      print("Error during biometric authentication: $e");
      return false;
    }
  }
}
