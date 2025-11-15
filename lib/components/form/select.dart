import 'package:flutter/material.dart';
import "package:projet_ia/components/form/input_decoration.dart";

class SelectInput extends StatefulWidget {
  final List<DropdownMenuItem<String>>? items;
  final Function getOption;
  dynamic? defaultValue;

  SelectInput({
    super.key,
    required this.items,
    required this.getOption,
    this.defaultValue = "",
  });

  @override
  State<SelectInput> createState() => _SelectInputState();
}

class _SelectInputState extends State<SelectInput> {
  String? selectedValue;
  @override
  void initState() {
    super.initState();
    setState(() {
      selectedValue =
          widget.defaultValue != ""
              ? widget.defaultValue
              : widget.items!.first.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: MyInputDecoration("Pays (obligatoire"),
        // decoration: const InputDecoration(
        //   labelText: 'Genre',
        //   isDense: true,
        //   border: OutlineInputBorder(),
        // ),
        items: widget.items,
        onChanged:
            (value) => {
              setState(() => selectedValue = value),
              widget.getOption(value),
            },
      ),
    );
  }
}
