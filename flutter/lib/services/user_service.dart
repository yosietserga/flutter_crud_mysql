import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fire_crud_mysql/models/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// @see https://github.com/biner88/mysql_utils

class UserService extends ChangeNotifier {
  final List<User> carsList = [];
  String error = '';
  String verificationId = '';
  String collection = 'users';

  late User user;

  final bool _isLoading = false;
  final bool _debug = dotenv.env['DEBUG'] == "true" ? true : false;

  set isLoading(bool value) => _isLoading;
  bool get isLoading => _isLoading;

  UserService() {
    user = User(password: "", email: "-", fecha: "-", usuario: 'USUARIO');
  }

  signOut() async {
    user = User(password: "", email: "-", fecha: "-", usuario: 'USUARIO');
    return null;
  }

  Future<String> readToken() async {
    final doc = await getAll({"id": 0});
    return "1";
  }

  String getUsername() {
    return user.usuario;
  }

  mailLogin(String email, String password) async {
    var url = Uri(
        scheme: 'http',
        host: '192.168.0.105',
        path: '/projects/flutter_backend/',
        queryParameters: {"route": "login"});

    http.Response response =
        await http.post(url, body: {"username": email, "password": password});
    var u = jsonDecode(response.body);
    if (u["id"] != null && u["id"].isNotEmpty) {
      user = User(
          id: u["id"],
          password: u["password"],
          fecha: "-",
          email: u["password"],
          usuario: u["username"]);
    }
    return u;
  }

  emailRegister(String email, String password) async {
    var url = Uri(
        scheme: 'http',
        host: '192.168.0.105',
        path: '/projects/flutter_backend/',
        queryParameters: {"route": "adduser"});
    print("DATA: $email and $password and $url");

    http.Response response = await http.post(url,
        body: {"username": email, "email": email, "password": password});
    var u = jsonDecode(response.body);
    if (u["id"] != null && u["id"].isNotEmpty) {
      user = User(
          id: u["id"],
          password: u["password"],
          fecha: "-",
          email: u["password"],
          usuario: u["username"]);
    }
    return u;
  }

  Future<User> getUser(int id) async {
    final doc = await getAll({id: id});
    return doc[0];
  }

  Future getAll(criteria) async {
    var url = Uri(
        scheme: 'http',
        host: '192.168.0.105',
        path: '/projects/flutter_backend/',
        queryParameters: {"route": "getUser"});

    http.Response response = await http.get(url);
    var rows = jsonDecode(response.body);

    if (rows.isEmpty) return [];

    var list_ = [];

    for (var data in rows) {
      final User tmp = User.fromMap(data);
      list_.add(tmp.toMap());
    }

    return list_;
  }

  Future<User?> saveUser(Map<String, dynamic> data) async {
    var id = 0;

    if (data["id"] == -1) {
      var url = Uri(
          scheme: 'http',
          host: '192.168.0.105',
          path: '/projects/flutter_backend/',
          queryParameters: {"route": "adduser"});

      http.Response response = await http.post(url, body: data);

      final user = jsonDecode(response.body);
      id = user != null ? user.toMap()["id"] : 0;
    } else {
      var url = Uri(
          scheme: 'http',
          host: '192.168.0.105',
          path: '/projects/flutter_backend/',
          queryParameters: {"route": "updateuser"});

      http.Response response = await http.post(url, body: data);

      final user = jsonDecode(response.body);
      id = user["id"];
    }

    final doc = await getUser(id);
    return doc;
  }

  Future<void> deleteUser(int id) async {
    isLoading = true;
    notifyListeners();

    var url = Uri(
        scheme: 'http',
        host: '192.168.0.105',
        path: '/projects/flutter_backend/',
        queryParameters: {"route": "deleteuser"});

    http.Response response = await http.post(url, body: {"id": id});

    final res = jsonDecode(response.body);

    isLoading = false;
    notifyListeners();

    return res.affected_rows;
  }
}
