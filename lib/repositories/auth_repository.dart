import '../utils/validators.dart';

class AuthRepository {
  // Simulated login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate credentials locally
    if (!Validators.isValidEmail(email)) return false;
    if (!Validators.isValidPassword(password)) return false;

    // For now, always return true for valid format
    return true;
  }
}
