import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
        inputDecoration: const InputDecoration(
          labelText: 'Numéro de téléphone',
          isDense: true,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
