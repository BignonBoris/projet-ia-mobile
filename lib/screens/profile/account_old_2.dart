import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/providers/user_provider.dart';
import "package:projet_ia/components/form/text.dart";
import "package:projet_ia/components/form/country.dart";
import "package:projet_ia/components/form/phone.dart";
import 'package:projet_ia/components/form/date.dart';
import "package:projet_ia/components/form/select.dart";

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pseudoController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String pseudo = '';
  String? selectedCountry;
  String phoneNumber = '';
  DateTime? birthDate;
  String? selectedGenre;
  String email = '';
  String password = '';

  final ImageProvider defaultAvatar = const AssetImage('assets/avatar.png');
  ImageProvider? userAvatar;

  @override
  void initState() {
    super.initState();

    final userProvider = context.read<UserProvider>();

    _pseudoController = TextEditingController(text: userProvider.pseudo);
    _emailController = TextEditingController(text: userProvider.email);
    _passwordController = TextEditingController(text: userProvider.password);
    // pseudo = userProvider.pseudo ?? '';
    // selectedCountry = userProvider.pays ?? 'Bénin';
    // phoneNumber = userProvider.phone ?? '';
    // // birthDate = userProvider.birth;
    // birthDate = DateTime.now();
    // selectedGenre = userProvider.genre;
    // email = userProvider.email ?? '';
    // // userAvatar = userProvider.avatar ?? defaultAvatar;
    // userAvatar = defaultAvatar;
  }

  void _pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() => selectedCountry = country.name);
      },
    );
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
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = context.watch<UserProvider>();

    return Container(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📸 Photo de profil
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(radius: 50, backgroundImage: userAvatar),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: ajouter image picker
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Changement de photo à venir..."),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.pinkAccent,
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "Informations personnelles",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextInput(controller: _pseudoController, label: "Pseudo"),

              // TextFormField(
              //   initialValue: pseudo,
              //   decoration: const InputDecoration(
              //     labelText: 'Pseudo',
              //     border: OutlineInputBorder(),
              //   ),
              //   onChanged: (v) => pseudo = v,
              // ),
              const SizedBox(height: 16),
              // CountryInput(selectedCountry: selectedCountry),

              // // 🌍 Sélection du pays
              // GestureDetector(
              //   onTap: _pickCountry,
              //   child: AbsorbPointer(
              //     child: TextFormField(
              //       decoration: InputDecoration(
              //         labelText: 'Pays',
              //         hintText: selectedCountry ?? 'Choisir un pays',
              //         border: const OutlineInputBorder(),
              //         suffixIcon: const Icon(Icons.arrow_drop_down),
              //       ),
              //       controller: TextEditingController(
              //         text: selectedCountry ?? '',
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),

              // PhoneInput(),

              // // 📱 Numéro de téléphone
              // InternationalPhoneNumberInput(
              //   onInputChanged: (PhoneNumber number) {
              //     setState(() => phoneNumber = number.phoneNumber ?? '');
              //   },
              //   initialValue: PhoneNumber(isoCode: 'BJ'),
              //   inputDecoration: const InputDecoration(
              //     labelText: 'Numéro de téléphone',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              const SizedBox(height: 16),

              DateInput(
                // initialDate: user.birthDate, // récupéré de ton UserProvider
                initialDate: birthDate,
                onDateSelected: (date) {
                  print(date);
                  // context.read<UserProvider>().updateBirthDate(date);
                },
              ),

              // // 🎂 Date de naissance
              // GestureDetector(
              //   onTap: _pickBirthDate,
              //   child: AbsorbPointer(
              //     child: TextFormField(
              //       decoration: InputDecoration(
              //         labelText: 'Date de naissance',
              //         border: const OutlineInputBorder(),
              //         suffixIcon: const Icon(Icons.calendar_today),
              //       ),
              //       controller: TextEditingController(
              //         text:
              //             birthDate != null
              //                 ? "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}"
              //                 : '',
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),

              // SelectInput(selectedValue: selectedGenre),

              // // 🚻 Genre
              // DropdownButtonFormField<String>(
              //   value: selectedGenre,
              //   decoration: const InputDecoration(
              //     labelText: 'Genre',
              //     border: OutlineInputBorder(),
              //   ),
              //   items: const [
              //     DropdownMenuItem(value: 'Homme', child: Text('Homme')),
              //     DropdownMenuItem(value: 'Femme', child: Text('Femme')),
              //     DropdownMenuItem(value: 'Autre', child: Text('Autre')),
              //   ],
              //   onChanged: (value) => setState(() => selectedGenre = value),
              // ),
              const SizedBox(height: 30),
              const Text(
                "Informations de connexion",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextInput(controller: _emailController, label: "Email"),

              // TextFormField(
              //   initialValue: email,
              //   decoration: const InputDecoration(
              //     labelText: 'Email',
              //     border: OutlineInputBorder(),
              //   ),
              //   onChanged: (v) => email = v,
              // ),
              const SizedBox(height: 16),

              // TextFormField(
              //   obscureText: true,
              //   initialValue: password,
              //   decoration: const InputDecoration(
              //     labelText: 'Mot de passe',
              //     border: OutlineInputBorder(),
              //   ),
              //   onChanged: (v) => password = v,
              // ),
              TextInput(controller: _passwordController, label: "Mot de passe"),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    print(_pseudoController.text);
                    print(_emailController.text);
                    if (_formKey.currentState!.validate()) {
                      // userProvider.updateUser(
                      //   pseudo: pseudo,
                      //   country: selectedCountry,
                      //   phone: phoneNumber,
                      //   birth: birthDate,
                      //   genre: selectedGenre,
                      //   email: email,
                      // );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profil mis à jour ✅')),
                      );
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Enregistrer les modifications"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
