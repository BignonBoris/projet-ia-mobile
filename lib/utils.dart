import 'package:flutter/material.dart';
import "package:projet_ia/classes/user.dart";

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

bool checkUserProfilComplet(UserModel? user) {
  return (user != null) &&
      (user.pseudo != null && user.pseudo != "") &&
      (user.dateOfBirth != null && user.dateOfBirth != "") &&
      (user.sexe != null && user.sexe != "") &&
      (user.country != null && user.country != "");
}

int calculateAge(String birthDateString) {
  // Convertir la chaîne en DateTime
  DateTime birthDate = DateTime.parse(birthDateString);

  DateTime today = DateTime.now();
  int age = today.year - birthDate.year;

  // Vérifier si l'anniversaire est déjà passé cette année
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }

  return age;
}
