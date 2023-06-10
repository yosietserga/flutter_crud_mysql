import 'dart:convert';

class User {
  User(
      {this.id = '-1',
      required this.usuario,
      required this.password,
      required this.email,
      required this.fecha});

  String? id;
  String usuario;
  String password;
  String email;
  String fecha;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        usuario: json["usuario"],
        password: json["password"],
        email: json["email"],
        fecha: json["fecha"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "usuario": usuario,
        "password": password,
        "email": email,
        "fecha": fecha,
      };

  User clone() => User(
        id: id,
        usuario: usuario,
        password: password,
        email: email,
        fecha: fecha,
      );
}
