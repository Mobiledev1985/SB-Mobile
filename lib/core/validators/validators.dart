// Validating user input that return string if validation failed otherwise return null
import 'package:flutter/services.dart';

abstract final class Validators {
  static String? emailValidator(String? email) {
    if (email == null) return null;
    email = email.trim();
    if (email.isEmpty) {
      return "Field cant be empty";
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return "Invalid Email Address";
    }
    return null;
  }

  static String? numberValidator(String? number) {
    if (number == null) return null;
    number = number.trim();
    if (number.isEmpty) {
      return "Field cant be empty";
    } else {
      try {
        int.parse(number);
      } on FormatException {
        return "Invalid Number";
      }
    }

    return null;
  }

  static String? nameValidator(String? name) {
    if (name == null) return null;
    if (name.isEmpty) {
      return "Field cant be empty";
    }
    return null;
  }

  static String? emptyValidator(String? name) {
    if (name == null) return null;
    if (name.isEmpty) {
      return "Field cant be empty";
    }
    return null;
  }

  static String? passwordValidator(String? password) =>
      password!.isNotEmpty && password.length > 2
          ? null
          : password.length < 3
              ? "Password should be of min. 3 digits"
              : "Not Valid";

  static String? passwordConfirmValidator(
          String? password, String? newPassword) =>
      newPassword != null && newPassword.isNotEmpty && newPassword.length > 2
          ? newPassword != password
              ? "Password don't match"
              : null
          : newPassword != null && newPassword.length < 3
              ? "Password should be of min. 3 digits"
              : "Not Valid";

  static String? emailConfirmValidator(String? email, String? confirmEmail) {
    // Check if the email is null or empty
    if (confirmEmail == null || confirmEmail.isEmpty) {
      return "Email is required";
    }

    // Check if the email is a valid email address
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegExp.hasMatch(confirmEmail)) {
      return "Invalid email format";
    }

    // Check if the email matches the confirmEmail
    if (email != confirmEmail) {
      return "Emails do not match";
    }

    return null; // Validation passed
  }

  static String? phoneNumberValidator(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "Field cant be empty";
    }
    return null;
  }
}

class MaxLengthFormatter extends TextInputFormatter {
  /// Custom formatter for maximum [maxLength] value
  MaxLengthFormatter(this.maxLength);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    } else if (double.parse(newValue.text) <= maxLength) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
