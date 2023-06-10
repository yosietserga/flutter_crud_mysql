import 'dart:convert';

class Ficha {
  Ficha(
      {this.id = -1,
      required this.usuario,
      required this.local,
      required this.maquina,
      required this.repuesto,
      required this.observaciones,
      required this.fecha,
      required this.parada,
      required this.foto1,
      required this.foto2,
      required this.foto3});

  int id;
  String usuario;
  String local;
  String maquina;
  String repuesto;
  String observaciones;
  String fecha;
  String parada;
  String foto1;
  String foto2;
  String foto3;

  factory Ficha.fromJson(String str) => Ficha.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ficha.fromMap(Map<String, dynamic> json) => Ficha(
        id: json["id"],
        usuario: json["usuario"] ?? "",
        local: json["local"] ?? "",
        maquina: json["maquina"] ?? "",
        repuesto: json["repuesto"] ?? "",
        observaciones: json["observaciones"] ?? "",
        fecha: json["fecha"] ?? "",
        parada: json["parada"] ?? "-",
        foto1: json["foto1"] ?? "",
        foto2: json["foto2"] ?? "",
        foto3: json["foto3"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "usuario": usuario,
        "local": local,
        "maquina": maquina,
        "repuesto": repuesto,
        "observaciones": observaciones,
        "fecha": fecha,
        "parada": parada,
        "foto1": foto1,
        "foto2": foto2,
        "foto3": foto3,
      };

  Ficha clone() => Ficha(
        id: id,
        usuario: usuario,
        local: local,
        maquina: maquina,
        repuesto: repuesto,
        observaciones: observaciones,
        fecha: fecha,
        parada: parada,
        foto1: foto1,
        foto2: foto2,
        foto3: foto3,
      );
}
