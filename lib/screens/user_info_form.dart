import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projet_ia/classes/user.dart';
import 'package:projet_ia/screens/home.dart';
import 'package:projet_ia/services/users_service.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/providers/user_id_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_ia/utils.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final UserService userService = UserService();

  final TextEditingController nameController = TextEditingController();
  // final TextEditingController countryController = TextEditingController();

  // Champs
  String name = "";
  int age = 0;
  String gender = "";
  // String country = "";

  void createUser() async {
    var userProvider = context.read<UserIdProvider>();
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });

    final response = await userService.createUser(
      new User(name: name, age: age, sexe: gender),
    );

    print(response);

    if (response.length == 36) {
      userProvider.setUserId(response);

      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text("Formulaire soumis ✅")));

      await prefs.setString('onboarding_done', response);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vérifiez votre connexxion internet et ressayer"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white, // Couleur de fond
      //   title: const Text(""),
      // ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white, // rose clair
              // Color(0xFFc3cfe2), // bleu-gris clair
              Colors.indigo,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50.0,
                        horizontal: 12.0,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Ici, tout commence par vous.",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Remplissez ce formulaire pour créer votre espace intime et profiter d’échanges personnalisés.",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Nom
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true, // Active le fond
                        fillColor: Colors.white, // Fond blanc
                        labelText: "Nom",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ), // Bordure transparente
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onChanged:
                          (value) => formattedInputText(value, nameController),
                      onSaved: (value) => name = value ?? "",
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Entrez votre nom"
                                  : null,
                    ),
                    const SizedBox(height: 50),

                    // Âge
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true, // Active le fond
                        fillColor: Colors.white, // Fond blanc
                        labelText: "Âge",
                        suffixText: "ans",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ), // Bordure transparente
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // 👈 empêche les lettres et symboles
                      ],
                      onSaved: (value) => age = int.tryParse(value ?? "")!,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Entrez votre âge"
                                  : int.tryParse(value)! < 15
                                  ? "Age suppérieur a 15 ans"
                                  : null,
                    ),
                    const SizedBox(height: 50),

                    // Sexe
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true, // Active le fond
                        fillColor: Colors.white, // Fond blanc
                        labelText: "Sexe",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ), // Bordure transparente
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items:
                          ["Homme", "Femme"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (value) => gender = value!,
                      validator:
                          (value) =>
                              value == null ? "Sélectionnez votre sexe" : null,
                    ),

                    // const SizedBox(height: 30),

                    // // Pays
                    // TextFormField(
                    //   controller: countryController,
                    //   decoration: InputDecoration(
                    //     filled: true, // Active le fond
                    //     fillColor: Colors.white, // Fond blanc
                    //     labelText: "Pays",
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.transparent),
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //   ),
                    //   textCapitalization: TextCapitalization.sentences,
                    //   onChanged:
                    //       (value) =>
                    //           formattedInputText(value, countryController),
                    //   onSaved: (value) => country = value!,
                    //   validator:
                    //       (value) =>
                    //           value == null || value.isEmpty
                    //               ? "Entrez votre pays"
                    //               : null,
                    // ),
                  ],
                ),
              ),

              // Bouton en bas
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null // 👈 empêche double clic
                            : () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                print("Nom: $name, Âge: $age, Sexe: $gender");
                                createUser();
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white, // 👈 couleur du spinner
                              ),
                            )
                            : const Text(
                              "Soumettre",
                              style: TextStyle(fontSize: 18),
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
