import 'package:fire_crud_mysql/models/ficha.dart';
import 'package:flutter/material.dart';

class FichaFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  Ficha ficha;

  FichaFormProvider(this.ficha);

  Ficha get getFicha => ficha;

  void setFicha(Ficha f) {
    ficha = f;
  }
}
