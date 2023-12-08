class User {
  final String? id;

  final String? email;
  final String? password;

  User({this.email, this.password, this.id});
}

class ProfileUser {
  final String? id;
  final String user;

  final String? firstname;
  final String? lastname;
  final String? age;
  final String? phone;
  final List image;
  ProfileUser(
      {this.firstname,
      this.lastname,
      this.age,
      this.phone,
      required this.image,
      required this.user,
      this.id});
}
