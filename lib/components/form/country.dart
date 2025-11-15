import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import "package:projet_ia/components/form/input_decoration.dart";

class CountryInput extends StatefulWidget {
  final Function getCountry;
  final String? defaultCountry;

  const CountryInput({
    super.key,
    required this.getCountry,
    this.defaultCountry = "",
  });

  @override
  State<CountryInput> createState() => _CountryInputState();
}

class _CountryInputState extends State<CountryInput> {
  String? selectedCountry;
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedCountry = widget.defaultCountry;
    });
  }

  void _pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() => selectedCountry = country.name);
        widget.getCountry(country);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _pickCountry,
        child: AbsorbPointer(
          child: TextFormField(
            decoration: MyInputDecoration("Pays (obligatoire)"),
            // decoration: InputDecoration(
            //   labelText: 'Pays (obligatoire)',
            //   isDense: true,
            //   hintText: selectedCountry ?? 'Choisir un pays',
            //   border: const OutlineInputBorder(),
            //   suffixIcon: const Icon(Icons.arrow_drop_down),
            // ),
            // controller: widget.controller,
            controller: TextEditingController(text: selectedCountry ?? ''),
          ),
        ),
      ),
    );
  }
}
