class UserModel {
  int? userId;
  String name;
  String email;
  String password;
  int createdAt;

  UserModel({this.userId, required this.name, required this.email, required this.password, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'UserModel(email: $email, password: $password)';
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      createdAt: map['createdAt'] as int,
    );
  }
}
