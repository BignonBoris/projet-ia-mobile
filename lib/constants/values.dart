import 'package:shared_preferences/shared_preferences.dart';

const String matchingFormScreen = "FORM";
const String matchingListScreen = "LIST";
const String profilAccountScreen = "REGISTER";
const String profilLoginScreen = "LOGIN";
const String profilQRScreen = "QR";
const String profilScannerScreen = "SCANNER";

Future<String?> getPrefUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('onboarding_done');
}

Future<String?> getStringPref(String value) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(value);
}

Future<bool?> getBoolPref(String value) async {
  final prefs = await SharedPreferences.getInstance();
  print("value = $value");
  print("value = ${prefs.getBool(value)}");
  return prefs.getBool(value);
}
