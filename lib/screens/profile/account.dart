import "dart:io";
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/providers/user_provider.dart';
import "package:projet_ia/components/form/text.dart";
import "package:projet_ia/components/form/country.dart";
import "package:projet_ia/components/form/phone.dart";
import 'package:projet_ia/components/form/date2.dart';
import "package:projet_ia/components/form/select.dart";
import "package:projet_ia/services/users.dart";
import "package:projet_ia/classes/user.dart";
import "package:projet_ia/constants/values.dart";

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pseudoController = TextEditingController(
    text: "",
  );
  late TextEditingController _occupationController = TextEditingController(
    text: "",
  );
  late TextEditingController _emailController = TextEditingController(text: "");
  late TextEditingController _passwordController = TextEditingController(
    text: "",
  );

  UserProvider userProvider = UserProvider();
  UserService userService = UserService();

  String pseudo = '';
  String? selectedCountry = "";
  String? phoneNumber = '';
  String? dateOfBirth = '';
  // DateTime? dateOfBirth;
  String? selectedGenre = "Homme";
  String email = '';
  String password = '';
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final ImageProvider defaultAvatar = const AssetImage('assets/avatar.png');
  ImageProvider? userAvatar;
  bool isLoading = true;
  String? userId = "";
  String profileImagePath = "";

  void getUserInformation() async {
    userProvider = context.read<UserProvider>();
    userId = await getPrefUserId();
    if (userProvider.pseudo == "") {
      UserModel? userData = await UserService().getUser(userId!);
      if (userData != null) {
        final data = userData.toJson();
        userProvider.updateUser(data);
      }
    }
    _pseudoController = TextEditingController(text: userProvider.pseudo);
    _emailController = TextEditingController(text: userProvider.email);
    _passwordController = TextEditingController(text: userProvider.password);
    _occupationController = TextEditingController(
      text: userProvider.occupation,
    );
    setState(() {
      selectedCountry = userProvider.country;
      phoneNumber = userProvider.phone;
      selectedGenre = userProvider.sexe;
      dateOfBirth = userProvider.dateOfBirth;
      isLoading = false;
      // profileImagePath = userProvider.profileImagePath!;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  Future<void> updateUserInformation() async {
    // UserProvider user
    // if (_isEditing && _formKey.currentState!.validate()) {
    UserModel userModel = UserModel(
      pseudo: _pseudoController.text,
      country: selectedCountry,
      phone: phoneNumber,
      dateOfBirth: dateOfBirth,
      sexe: selectedGenre,
      occupation: _occupationController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    String response = await userService.updateUser(userId!, userModel);

    userProvider.updateUser({
      "pseudo": _pseudoController.text,
      "country": selectedCountry ?? "",
      "phone": phoneNumber ?? "",
      "dateOfBirth": dateOfBirth ?? "",
      "sexe": selectedGenre ?? "",
      "occupation": _occupationController.text,
      "email": _emailController.text,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profil mis à jour ✅")));
    // }
    // setState(() => _isEditing = !_isEditing);
  }

  void _openPasswordModal(BuildContext context) {
    final TextEditingController _newPassword = TextEditingController();
    final TextEditingController _confirmPassword = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "🔐 Modifier le mot de passe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _newPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Nouveau mot de passe",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("Valider"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  if (_newPassword.text == _confirmPassword.text &&
                      _newPassword.text.isNotEmpty) {
                    context.read<UserProvider>().updatePassword(
                      _newPassword.text,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Mot de passe mis à jour ✅"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Les mots de passe ne correspondent pas ❌",
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      await UserService().uploadProfileImage(userId!, pickedFile);
      context.read<UserProvider>().updateProfileImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    // userProvider = context.watch<UserProvider>();

    return Container(
      child:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                            profileImagePath == "" || profileImagePath.isEmpty
                                ? const CircleAvatar(
                                  radius: 50,
                                  child: Icon(Icons.person),
                                )
                                : CircleAvatar(
                                  radius: 50,
                                  // backgroundImage: userAvatar,
                                  backgroundImage:
                                      _imageFile != null
                                          ? FileImage(_imageFile!)
                                          : profileImagePath.isNotEmpty
                                          ? NetworkImage(profileImagePath)
                                          : (userProvider.profileImagePath !=
                                                  null
                                              ? FileImage(
                                                File(
                                                  userProvider
                                                      .profileImagePath!,
                                                ),
                                              )
                                              : const AssetImage(
                                                    "assets/default_avatar.png",
                                                  )
                                                  as ImageProvider),

                                  // profileImagePath.isNotEmpty
                                  //     ? NetworkImage(profileImagePath)
                                  //     : _imageFile != null
                                  //     ? FileImage(_imageFile!)
                                  //     : (userProvider.profileImagePath != null
                                  //         ? FileImage(
                                  //           File(
                                  //             userProvider.profileImagePath!,
                                  //           ),
                                  //         )
                                  //         : const AssetImage(
                                  //               "assets/default_avatar.png",
                                  //             )
                                  //             as ImageProvider),
                                ),
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: GestureDetector(
                                onTap: _pickImage,
                                // onTap: () {
                                //   // TODO: ajouter image picker
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     const SnackBar(
                                //       content: Text(
                                //         "Changement de photo à venir...",
                                //       ),
                                //     ),
                                //   );
                                // },
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
                      const SizedBox(height: 15),

                      // --- Section 1 : Informations personnelles
                      Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.blue),
                                  SizedBox(width: 8),
                                  _sectionTitle("Informations personnelles"),
                                ],
                              ),
                              const SizedBox(height: 5),
                              TextInput(
                                controller: _pseudoController,
                                label: "Nom d'utilisateur (obligatoire)",
                              ),
                              const SizedBox(height: 5),
                              CountryInput(
                                defaultCountry: selectedCountry,
                                getCountry:
                                    (Country value) => {
                                      setState(
                                        () => selectedCountry = value.name,
                                      ),
                                    },
                              ),
                              PhoneInput(
                                defaultPhone: phoneNumber,
                                getPhone:
                                    (PhoneNumber value) => {
                                      setState(
                                        () => phoneNumber = value.phoneNumber,
                                      ),
                                    },
                              ),

                              DateInput(
                                defaultDate: dateOfBirth,
                                getDate:
                                    (DateTime? value) => {
                                      setState(
                                        () => dateOfBirth = value.toString(),
                                      ),
                                    },
                              ),
                              const SizedBox(height: 5),

                              SelectInput(
                                defaultValue: selectedGenre,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Homme',
                                    child: Text('Homme'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Femme',
                                    child: Text('Femme'),
                                  ),
                                ],
                                getOption:
                                    (value) => {
                                      print(value),
                                      setState(() => selectedGenre = value),
                                    },
                              ),

                              const SizedBox(height: 10),
                              TextInput(
                                controller: _occupationController,
                                label: "Profession",
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- Section 2 : Informations de connexion
                      Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lock, color: Colors.green),
                                  SizedBox(width: 8),
                                  _sectionTitle("Informations de connexion"),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextInput(
                                controller: _emailController,
                                label: "Email",
                              ),
                              const SizedBox(height: 16),
                              (userProvider.password == "")
                                  ? TextInput(
                                    controller: _passwordController,
                                    label: "Mot de passe",
                                    isPassword: true,
                                  )
                                  : ListTile(
                                    title: const Text("Mot de passe"),
                                    subtitle: const Text("********"),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.lock),
                                      tooltip: "Modifier le mot de passe",
                                      onPressed:
                                          () => _openPasswordModal(context),
                                    ),
                                  ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => updateUserInformation(),
                          // {
                          //   // if (_formKey.currentState!.validate()) {
                          //   // userProvider.updateUser(
                          //   //   pseudo: pseudo,
                          //   //   country: selectedCountry,
                          //   //   phone: phoneNumber,
                          //   //   birth: dateOfBirth,
                          //   //   sexe: selectedGenre,
                          //   //   email: email,
                          //   // );
                          //   // }
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(content: Text('Profil mis à jour ✅')),
                          //   );
                          // },
                          icon: const Icon(Icons.save),
                          label: Text(
                            "${userProvider.pseudo == '' ? 'Créer un compte' : 'Enregistrer les modifications'}",
                          ),
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

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
