import 'package:flutter/material.dart';

void formattedInputText(String value, TextEditingController inputText) {
  if (value.isNotEmpty) {
    final formatted = value[0].toUpperCase() + value.substring(1);
    if (formatted != value) {
      inputText.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }
}
