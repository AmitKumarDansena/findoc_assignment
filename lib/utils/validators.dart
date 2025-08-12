/// Utility functions for input validation.
class Validators {
  /// Validates if the provided string is a correctly formatted email address.
  ///
  /// Returns `true` if the email is valid, `false` otherwise.
  static bool isValidEmail(String email) {
    // A simple regex for basic email validation.
    // This checks for the general structure: something@something.something
    // It's not exhaustive but covers most common cases.
    // For stricter validation, more complex regex or dedicated packages can be used.
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  /// Validates if the provided string meets the password complexity requirements.
  ///
  /// Requirements:
  /// - Minimum 8 characters
  /// - At least one uppercase letter (A-Z)
  /// - At least one lowercase letter (a-z)
  /// - At least one digit (0-9)
  /// - At least one special character (!@#$%^&*(),.?":{}|<>)
  ///
  /// Returns `true` if the password is valid, `false` otherwise.
  static bool isValidPassword(String password) {
    if (password.length < 8) {
      return false;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    // Includes common special characters. You can adjust the set as needed.
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }
}