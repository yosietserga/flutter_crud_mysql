import 'package:flutter/material.dart';

// ignore: slash_for_doc_comments
/**
 * Este Widget sera el contenedor de otro widget enviado por parametros
 * con la configuracion especificada
 */
class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: _CreateCardShape(),
            child: child));
  }

  BoxDecoration _CreateCardShape() => BoxDecoration(
          color: const Color.fromARGB(255, 221, 220, 220),
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))
          ]);
}
