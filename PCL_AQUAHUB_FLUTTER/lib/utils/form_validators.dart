/// Form validation utilities with more robust checks and user-friendly error messages.
class FormValidators {
  /// Validates email format using a simple regex pattern.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    const emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
    final isValid = RegExp(emailRegex).hasMatch(value);
    if (!isValid) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password strength (minimum 8 characters, at least one digit and one uppercase).
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'\d'))) {
      return 'Password must contain at least one digit';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    return null;
  }

  /// Validates that password and confirmation match.
  static String? validatePasswordConfirm(String? value, String passwordValue) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordValue) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates phone number (basic: 10+ digits).
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }

  /// Validates that a field is not empty.
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates postal code (basic: alphanumeric, 3-10 chars).
  static String? validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postal code is required';
    }
    if (value.length < 3 || value.length > 10) {
      return 'Postal code must be between 3 and 10 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s-]+$').hasMatch(value)) {
      return 'Postal code can only contain letters, numbers, spaces, and hyphens';
    }
    return null;
  }
}
