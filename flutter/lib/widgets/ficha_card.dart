import 'package:flutter/material.dart';
import 'package:fire_crud_mysql/models/ficha.dart';

class FichaCard extends StatelessWidget {
  final Ficha car;
  const FichaCard({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: _cardBorders(),
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Padding(
                  padding: const EdgeInsets.all(8.0), child: Text(car.maquina)),
              Positioned(top: 0, right: 0, child: _TagLabel(fecha: car.fecha))
            ])));
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _TagLabel extends StatelessWidget {
  final String fecha;
  const _TagLabel({
    Key? key,
    required this.fecha,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5), bottomLeft: Radius.circular(5))),
        child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(fecha,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            )));
  }
}
