class UserModel {
  String? user_id;
  String? image;
  String? pseudo;
  String? phone;
  String? dateOfBirth;
  String? sexe;
  String? occupation;
  String? email;
  String? password;
  String? name;
  int? age;
  String? country;
  String? fcmToken;
  String? imageProfile;

  UserModel({
    this.user_id,
    this.image,
    this.pseudo,
    this.phone,
    this.dateOfBirth,
    this.sexe,
    this.occupation,
    this.email,
    this.password,
    this.name,
    this.age,
    this.country,
    this.fcmToken,
    this.imageProfile,
  });

  UserModel.empty()
    : this.user_id = "",
      this.image = "",
      this.pseudo = "",
      this.phone = "",
      this.dateOfBirth = "",
      this.sexe = "",
      this.occupation = "",
      this.email = "",
      this.password = "",
      this.name = "",
      this.age = 0,
      this.country = "",
      this.fcmToken = "",
      this.imageProfile = "";

  // Convertir un Map JSON → UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'],
      image: json['image'],
      pseudo: json['pseudo'],
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'],
      // dateOfBirth:
      //     json['dateOfBirth'] != null && json['dateOfBirth'] != ""
      //         ? DateTime.parse(json['dateOfBirth'])
      //         : "",
      sexe: json['sexe'],
      occupation: json['occupation'],
      password: json['password'],
      name: json['name'],
      age: json['age'],
      country: json['country'],
      fcmToken: json['fcmToken'],
      email: json["email"],
      imageProfile: json["imageProfile"],
    );
  }

  // Add the toJson() method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "user_id": user_id ?? "",
      'image': image ?? "",
      'pseudo': pseudo ?? "",
      'phone': phone ?? "",
      'dateOfBirth': dateOfBirth ?? "",
      // 'dateOfBirth': dateOfBirth!.toIso8601String(),
      'sexe': sexe ?? "",
      'occupation': occupation ?? "",
      'email': email ?? "",
      'password': password ?? "",
      'name': name ?? "",
      'age': age ?? 0,
      'country': country ?? "",
      'fcmToken': fcmToken ?? "",
      'imageProfile': imageProfile ?? "",
    };

    return data;
  }
}
