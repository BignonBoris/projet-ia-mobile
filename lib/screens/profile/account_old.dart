import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:projet_ia/components/form/date.dart';
import 'package:projet_ia/providers/user_provider.dart';
import "package:projet_ia/screens/profile/login.dart";
import "package:projet_ia/services/users.dart";
import "package:projet_ia/classes/user.dart";

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isEditing = false;

  late TextEditingController _pseudoController;
  late TextEditingController _paysController;
  late TextEditingController _phoneController;
  late TextEditingController _birthController;
  late TextEditingController _genreController;
  late TextEditingController _occupationController;
  late TextEditingController _emailController;

  String uniqueId = "";
  UserService userService = UserService();

  String? _selectedCountry = "Bénin";
  PhoneNumber number = PhoneNumber(isoCode: 'BJ'); // par défaut Bénin 🇧🇯
  String fullPhoneNumber = "";
  DateTime birthDay = DateTime(2000, 10, 10);
  String? selectedGenre; // variable dans ton State

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>();
    _pseudoController = TextEditingController(text: user.pseudo);
    _paysController = TextEditingController(text: user.country);
    _phoneController = TextEditingController(text: user.phone);
    _birthController = TextEditingController(text: user.dateOfBirth);
    _genreController = TextEditingController(text: user.sexe);
    _occupationController = TextEditingController(text: user.occupation);
    _emailController = TextEditingController(text: user.email);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      context.read<UserProvider>().updateProfileImage(pickedFile.path);
    }
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false, // désactive le code +229, facultatif
      favorite: ['BJ', 'FR', 'CI'], // tes country favoris
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country.name;
        });
      },
    );
  }

  Future<void> updateUserInformation(UserProvider user) async {
    if (_isEditing && _formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      uniqueId = prefs.getString('onboarding_done') ?? "";
      UserModel userModel = UserModel(
        pseudo: _pseudoController.text,
        country: _paysController.text,
        phone: _phoneController.text,
        // dateOfBirth: _birthController.text,
        sexe: _genreController.text,
        occupation: _occupationController.text,
        email: _emailController.text,
      );

      String response = await userService.updateUser(uniqueId, userModel);

      print({response});
      user.updateUser({
        "pseudo": _pseudoController.text,
        "country": _paysController.text,
        "phone": _phoneController.text,
        "dateOfBirth": _birthController.text,
        "sexe": _genreController.text,
        "occupation": _occupationController.text,
        "email": _emailController.text,
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profil mis à jour ✅")));
    }
    setState(() => _isEditing = !_isEditing);
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

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            tooltip: _isEditing ? "Enregistrer" : "Modifier",
            onPressed: () => updateUserInformation(user),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 👤 Photo de profil
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _imageFile != null
                              ? FileImage(_imageFile!)
                              : (user.profileImagePath != null
                                  ? FileImage(File(user.profileImagePath!))
                                  : const AssetImage(
                                        "assets/default_avatar.png",
                                      )
                                      as ImageProvider),
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.pinkAccent,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                user.pseudo,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              _sectionTitle("Informations personnelles"),
              _buildTextField("Pseudo", _pseudoController),
              _buildTextField("Pays", _paysController),

              InkWell(
                onTap: _selectCountry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCountry ?? "Choisir un country",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber value) {
                    setState(() => fullPhoneNumber = value.phoneNumber ?? '');
                    print("Numéro complet : $fullPhoneNumber");
                  },
                  onInputValidated: (bool isValid) {
                    print("Numéro valide ? $isValid");
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                    setSelectorButtonAsPrefixIcon: true,
                    leadingPadding: 12,
                    useEmoji: true,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  initialValue: number,
                  textFieldController: _phoneController,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  inputDecoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ex: 90 00 00 00',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                  ),
                  selectorTextStyle: const TextStyle(color: Colors.black),
                ),
              ),

              DateInput(
                // initialDate: user.dateOfBirth, // récupéré de ton UserProvider
                initialDate: birthDay,
                onDateSelected: (date) {
                  print(date);
                  // context.read<UserProvider>().updateBirthDate(date);
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedGenre,
                decoration: InputDecoration(
                  labelText: 'Genre',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Homme', child: Text('Homme')),
                  DropdownMenuItem(value: 'Femme', child: Text('Femme')),
                  DropdownMenuItem(value: 'Autre', child: Text('Autre')),
                ],
                onChanged: (value) => setState(() => selectedGenre = value),
              ),

              _buildTextField("Téléphone", _phoneController),
              _buildTextField("Date de naissance", _birthController),
              _buildTextField("Genre", _genreController),
              _buildTextField("Profession", _occupationController),

              const SizedBox(height: 25),

              _sectionTitle("Informations de connexion"),
              _buildTextField(
                "Adresse e-mail",
                _emailController,
                keyboard: TextInputType.emailAddress,
              ),

              ListTile(
                title: const Text("Mot de passe"),
                subtitle: const Text("********"),
                trailing: IconButton(
                  icon: const Icon(Icons.lock),
                  tooltip: "Modifier le mot de passe",
                  onPressed: () => _openPasswordModal(context),
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("Déconnexion"),
                            content: const Text(
                              "Souhaitez-vous vraiment vous déconnecter ?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Annuler"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Oui, déconnecter"),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      await context.read<UserProvider>().clearUser();

                      // Redirection vers l’écran de login
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Se déconnecter",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        obscureText: obscure,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: _isEditing ? const Icon(Icons.edit, size: 18) : null,
        ),
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return "Veuillez remplir ce champ";
        //   }
        //   return null;
        // },
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
