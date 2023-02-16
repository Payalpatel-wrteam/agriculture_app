import 'package:agriculture_app/helper/strings.dart';

class Validator {
  static String emailPattern =
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)"
      r"*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+"
      r"[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
  static validateEmail(String? email) {
    if (email!.trim().isEmpty) {
      return StringRes.emptyEmailMessage;
    } else if (!RegExp(emailPattern).hasMatch(email)) {
      return StringRes.invalidEmailMessage;
    } else {
      return null;
    }
  }

  static emptyValueValidation(String? value) {
    if (value!.trim().isEmpty) {
      return StringRes.emptyValueMessage;
    } else {
      return null;
    }
  }

  static validatePassword(String? value) {
    if (value!.trim().isEmpty) {
      return StringRes.emptyValueMessage;
    } else if (value.length < 6) {
      return StringRes.invalidPasswordLengthMessage;
    } else {
      return null;
    }
  }

  static validatePhoneNumber(String? value) {
    print('validate phone==$value');
    //below regex for indian number
    final pattern = RegExp(
        r"((\+*)((0[ -]*)*|((91 )*))((\d{12})+|(\d{10})+))|\d{5}([- ]*)\d{6}");
    if (value!.trim().isEmpty && !pattern.hasMatch(value)) {
      return StringRes.invalidPhoneMessage;
    } else {
      return null;
    }
  }

  static validateName(String? value) {
    final pattern = RegExp(r'^[a-zA-Z ]+$');
    if (value!.trim().isEmpty) {
      return StringRes.emptyValueMessage;
    } else if (!pattern.hasMatch(value)) {
      return StringRes.invalidNameMessage;
    } else {
      return null;
    }
  }
}
