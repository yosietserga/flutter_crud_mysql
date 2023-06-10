import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fire_crud_mysql/models/ficha.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FichaService extends ChangeNotifier {
  final List<Ficha> carsList = [];
  String error = '';
  String verificationId = '';
  String collection = 'ficha';

  late Ficha carSel;

  final bool _isLoading = false;
  final bool _debug = dotenv.env['DEBUG'] == "true" ? true : false;

  set isLoading(bool value) => _isLoading;
  bool get isLoading => _isLoading;

  FichaService() {
    carSel = Ficha(
        local: "-",
        maquina: "-",
        repuesto: "-",
        observaciones: "-",
        fecha: "-",
        parada: "-",
        foto1: "-",
        foto2: "-",
        foto3: "-",
        usuario: 'USUARIO');
  }

  Future<Ficha> getFicha(int? id) async {
    final doc = await getAll({id: id});
    return doc[0];
  }

  Future snapshot() async {
    final docs = await getAll({});
    return {"docs": docs};
  }

  Future<List> getAll(criteria) async {
    var _criteria = {};

    if (criteria["id"] != null) _criteria["id"] = criteria["id"];
    if (criteria["usuario"] != null) _criteria["usuario"] = criteria["usuario"];
    if (criteria["local"] != null) _criteria["local"] = criteria["local"];
    if (criteria["maquina"] != null) _criteria["maquina"] = criteria["maquina"];
    if (criteria["repuesto"] != null) {
      _criteria["repuesto"] = criteria["repuesto"];
    }
    if (criteria["parada"] != null) _criteria["parada"] = criteria["parada"];

    var url = Uri(
        scheme: 'http',
        host: '192.168.0.105',
        path: '/projects/flutter_backend/',
        queryParameters: {"route": "getFichas"});

    http.Response response = await http.get(url);
    var rows = jsonDecode(response.body);
    if (rows.isEmpty) return [];

    return rows;
  }

  Future<Map<String, dynamic>> saveFicha(Map<String, dynamic> data) async {
    var id = 0;

    if (data["id"] == -1) {
      var url = Uri(
          scheme: 'http',
          host: '192.168.0.105',
          path: '/projects/flutter_backend/',
          queryParameters: {"route": "addficha"});

      http.Response response = await http.post(url, body: {
        "usuario": data["usuario"] ?? "",
        "local": data["local"] ?? "",
        "maquina": data["maquina"] ?? "",
        "repuesto": data["repuesto"] ?? "",
        "observaciones": data["observaciones"] ?? "",
        "fecha": data["fecha"] ?? "",
        "parada": data["parada"] ?? "",
        "foto1": data["foto1"] ?? "",
        "foto2": data["foto2"] ?? "",
        "foto3": data["foto3"] ?? "",
      });

      final ficha = jsonDecode(response.body);

      id = ficha != null ? int.parse(ficha["id"]) : 0;
      return ficha;
    } else {
      var url = Uri(
          scheme: 'http',
          host: '192.168.0.105',
          path: '/projects/flutter_backend/',
          queryParameters: {"route": "updateficha"});

      data["id"] = "${data['id']}";
      http.Response response = await http.post(url, body: data);

      final ficha = jsonDecode(response.body);

      id = int.parse(ficha["id"]);
      return ficha;
    }
  }

  Future<int> deleteFicha(int id) async {
    isLoading = true;
    notifyListeners();

    var url = Uri(
        scheme: 'http',
        host: '192.168.0.105',
        path: '/projects/flutter_backend/',
        queryParameters: {"route": "deleteficha"});

    http.Response response = await http.post(url, body: {"id": "$id"});

    final res = jsonDecode(response.body);

    isLoading = false;
    notifyListeners();

    return int.parse(res["affected_rows"]);
  }

  Future upload(imageFile) async {
    isLoading = true;
    notifyListeners();

    var url = Uri(
        scheme: 'http',
        host: '192.168.0.105',
        path: '/projects/flutter_backend/',
        queryParameters: {"route": "upload"});

    final request = http.MultipartRequest("POST", url);

    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.headers.addAll({'Content-Type': 'multipart/form-data'});

    final response = await http.Client().send(request);
    print("RESPOMSE $response");
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed');
    }
  }
}
