import 'package:flutter/material.dart';

class DateInput extends StatefulWidget {
  final Function getDate;
  String? defaultDate;

  DateInput({super.key, required this.getDate, this.defaultDate = ""});

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime? birthDate;
  @override
  void initState() {
    super.initState();
    setState(() {
      birthDate =
          widget.defaultDate != "" ? DateTime.parse(widget.defaultDate!) : null;
      // birthDate = widget.defaultDate != "" ? DateTime.parse(widget.defaultDate) : "";
    });
  }

  void _pickBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.pinkAccent,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != birthDate) {
      setState(() => birthDate = picked);
      widget.getDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _pickBirthDate,
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Date de naissance  (obligatoire)',
              isDense: true,
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(
              text:
                  birthDate != null
                      ? "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}"
                      : '',
            ),
          ),
        ),
      ),
    );
  }
}
