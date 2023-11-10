import 'package:flutter/services.dart';

class MyFilter extends TextInputFormatter {
  static final _reg = RegExp(r'^\d+(\.\d*)?$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Handle backspace separately
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Check if the new value matches the regular expression
    if (_reg.hasMatch(newValue.text)) {
      return newValue;
    }

    // If not, return the old value
    return oldValue;
  }
}
