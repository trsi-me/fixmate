class User {
  final int id;
  final String email;
  final String name;
  final String? phone;
  final String? token;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      if (token != null) 'token': token,
    };
  }

  User copyWith({String? name, String? phone, String? token}) {
    return User(
      id: id,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      token: token ?? this.token,
    );
  }
}
