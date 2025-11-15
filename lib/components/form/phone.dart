import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import "package:projet_ia/components/form/input_decoration.dart";

class PhoneInput extends StatefulWidget {
  final Function getPhone;
  final String? defaultPhone;

  const PhoneInput({super.key, required this.getPhone, this.defaultPhone = ""});

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blueAccent.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child:
      // 📱 Numéro de téléphone
      InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          widget.getPhone(number);
          // setState(() => phoneNumber = number.phoneNumber ?? '');
        },
        // initialValue: PhoneNumber(
        //   isoCode: 'BJ',
        //   phoneNumber: widget.defaultPhone,
        // ),
        initialValue: PhoneNumber(
          isoCode: 'BJ',
          phoneNumber: widget.defaultPhone,
        ),
        // inputDecoration: MyInputDecoration("Pays (obligatoire"),
        inputDecoration: InputDecoration(
          hintText: "Numéro de téléphone",
          // labelText: 'Numéro de téléphone',
          isDense: true,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
