import '../constants/app_constants.dart';

class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Required email validation
  static String? requiredEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return email(value);
  }

  // Optional email validation
  static String? optionalEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    return email(value);
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    if (value.length > 50) {
      return 'Password must not exceed 50 characters';
    }
    
    return null;
  }

  // Strong password validation
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    // Check for uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    // Check for digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    // Check for special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // Name validation
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < AppConstants.minNameLength) {
      return 'Name must be at least ${AppConstants.minNameLength} characters long';
    }
    
    if (trimmed.length > AppConstants.maxNameLength) {
      return 'Name must not exceed ${AppConstants.maxNameLength} characters';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(trimmed)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }

  // Phone number validation
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.length != AppConstants.phoneNumberLength) {
      return 'Phone number must be ${AppConstants.phoneNumberLength} digits';
    }
    
    final phoneRegex = RegExp(AppConstants.phonePattern);
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid Indian phone number';
    }
    
    return null;
  }

  // Optional phone validation
  static String? optionalPhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    return phone(value);
  }

  // Age validation
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    
    if (age < AppConstants.minAge || age > AppConstants.maxAge) {
      return 'Age must be between ${AppConstants.minAge} and ${AppConstants.maxAge}';
    }
    
    return null;
  }

  // Income validation
  static String? income(String? value) {
    if (value == null || value.isEmpty) {
      return 'Income is required';
    }
    
    final income = double.tryParse(value.replaceAll(',', ''));
    if (income == null) {
      return 'Please enter a valid income amount';
    }
    
    if (income < AppConstants.minIncome || income > AppConstants.maxIncome) {
      return 'Income must be between ₹${AppConstants.minIncome} and ₹${AppConstants.maxIncome}';
    }
    
    return null;
  }

  // Optional income validation
  static String? optionalIncome(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    return income(value);
  }

  // Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Dropdown required validation
  static String? requiredDropdown(dynamic value, [String? fieldName]) {
    if (value == null) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Number validation
  static String? number(String? value, {int? min, int? max, String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    
    if (min != null && number < min) {
      return '${fieldName ?? 'Value'} must be at least $min';
    }
    
    if (max != null && number > max) {
      return '${fieldName ?? 'Value'} must be at most $max';
    }
    
    return null;
  }

  // Optional number validation
  static String? optionalNumber(String? value, {int? min, int? max, String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    return number(value, min: min, max: max, fieldName: fieldName);
  }

  // Children count validation
  static String? childrenCount(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    return number(value, min: 0, max: 20, fieldName: 'Number of children');
  }

  // Aadhar number validation
  static String? aadhar(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.length != 12) {
      return 'Aadhar number must be 12 digits';
    }
    
    final aadharRegex = RegExp(AppConstants.aadharPattern);
    if (!aadharRegex.hasMatch(cleaned)) {
      return 'Please enter a valid Aadhar number';
    }
    
    return null;
  }

  // PAN number validation
  static String? pan(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final cleaned = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    
    if (cleaned.length != 10) {
      return 'PAN number must be 10 characters';
    }
    
    final panRegex = RegExp(AppConstants.panPattern);
    if (!panRegex.hasMatch(cleaned)) {
      return 'Please enter a valid PAN number (e.g., ABCDE1234F)';
    }
    
    return null;
  }

  // URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  // Custom validation for combining multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  // Min length validation
  static String? Function(String?) minLength(int length, [String? fieldName]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '${fieldName ?? 'This field'} is required';
      }
      
      if (value.length < length) {
        return '${fieldName ?? 'This field'} must be at least $length characters';
      }
      
      return null;
    };
  }

  // Max length validation
  static String? Function(String?) maxLength(int length, [String? fieldName]) {
    return (String? value) {
      if (value != null && value.length > length) {
        return '${fieldName ?? 'This field'} must not exceed $length characters';
      }
      
      return null;
    };
  }

  // Range validation for strings
  static String? Function(String?) lengthRange(int min, int max, [String? fieldName]) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '${fieldName ?? 'This field'} is required';
      }
      
      if (value.length < min || value.length > max) {
        return '${fieldName ?? 'This field'} must be between $min and $max characters';
      }
      
      return null;
    };
  }
}
