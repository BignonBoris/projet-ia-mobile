class User {
  final String name;
  final int age;
  final String sexe;
  // final String country;

  User({
    required this.name,
    required this.age,
    required this.sexe,
    // required this.country,
  });

  User.empty() : this.name = "", this.age = 0, this.sexe = "";
}
