import 'package:flutter/material.dart';
import "package:projet_ia/components/form/input_decoration.dart";

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final bool? isPassword;

  const TextInput({
    super.key,
    required this.controller,
    this.label,
    this.isPassword,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: TextFormField(
        controller: widget.controller,
        // enabled: _isEditing,
        obscureText: widget.isPassword ?? false,
        decoration: MyInputDecoration(widget.label!),
        // decoration: InputDecoration(
        //   labelText: widget.label,
        //   border: const OutlineInputBorder(),
        //   isDense: true,
        //   // suffixIcon: _isEditing ? const Icon(Icons.edit, size: 18) : null,
        // ),

        // keyboardType: keyboard,
        // onChanged: (value) => {print(value)},
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return "Veuillez remplir ce champ";
        //   }
        //   return null;
        // },
      ),
    );
  }
}
