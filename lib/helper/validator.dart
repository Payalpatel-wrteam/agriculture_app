import 'package:agriculture_app/helper/strings.dart';

class Validator {
  static String emailPattern =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)"
      r"*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+"
      r"[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
  static validateEmail(String? email) {
    if (email!.isEmpty) {
      return StringRes.emptyEmailMessage;
    } else if (!RegExp(emailPattern).hasMatch(email)) {
      return StringRes.invalidEmailMessage;
    } else {
      return null;
    }
  }

  static emptyValueValidation(String? value) {
    if (value!.isEmpty) {
      return StringRes.emptyValueMessage;
    } else {
      return null;
    }
  }

  static validatePassword(String? value) {
    if (value!.isEmpty) {
      return StringRes.emptyValueMessage;
    } else if (value.length < 6) {
      return StringRes.invalidPasswordLengthMessage;
    } else {
      return null;
    }
  }

  static validatePhoneNumber(String? value) {
    final pattern =
        RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}");
    if (value!.isNotEmpty && !pattern.hasMatch(value)) {
      return StringRes.invalidPhoneMessage;
    } else {
      return null;
    }
  }

  static validateName(String? value) {
    final pattern = RegExp(r'^[a-zA-Z ]+$');
    if (value!.isEmpty) {
      return StringRes.emptyValueMessage;
    } else if (!pattern.hasMatch(value)) {
      return StringRes.invalidNameMessage;
    } else {
      return null;
    }
  }
}
