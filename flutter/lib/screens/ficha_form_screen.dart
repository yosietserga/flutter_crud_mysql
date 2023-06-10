import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:fire_crud_mysql/models/ficha.dart';
import 'package:fire_crud_mysql/screens/screens.dart';
import 'package:fire_crud_mysql/providers/providers.dart';
import 'package:fire_crud_mysql/services/services.dart';

class FichaFormScreen extends StatelessWidget {
  static const String routerName = "FichaFormScreen";
  const FichaFormScreen({Key? key, this.c}) : super(key: key);
  final Ficha? c;
  @override
  Widget build(BuildContext context) {
    final FichaService carService = Provider.of<FichaService>(context);

    return ChangeNotifierProvider(
      create: (_) => FichaFormProvider(carService.carSel),
      child: _CarBody(carService: carService, c: c),
    );
  }
}

class _CarBody extends StatelessWidget {
  final FichaService carService;
  final Ficha? c;
  const _CarBody({Key? key, required this.carService, this.c})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserService>(context, listen: false);
    final List<String> statuses = ['-', 'S', 'N'];
    final carForm = Provider.of<FichaFormProvider>(context);
    Ficha carSel = c ?? carForm.ficha;

    String? parada;
    String? foto1;
    String? foto2;
    String? foto3;

    //Se agrega para poder editar el texto desde codigo
    var maquina = TextEditingController();
    var local = TextEditingController();
    var repuesto = TextEditingController();
    var observaciones = TextEditingController();
    var fecha = TextEditingController();
    var usuario = TextEditingController();

    if (c != null) {
      //usuario.text = carSel.usuario ?? authService.user.usuario;
      local.text = carSel.local;
      maquina.text = carSel.maquina;
      repuesto.text = carSel.repuesto;
      observaciones.text = carSel.observaciones;
      fecha.text = carSel.fecha;
    }

    const placeholderImage =
        'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Ficha Form'),
          leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(placeholderImage))),
          actions: [
            IconButton(
                onPressed: () {
                  authService.signOut(); //Cierra session
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routerName);
                },
                icon: const Icon(Icons.login_outlined))
          ]),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Center(
            child: TextButton(
              child: const Text('Go Back'),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
            ),
          ),
          /*
          Column(children: [
            TextFormField(
                controller: usuario,
                enabled: false,
                decoration: const InputDecoration(
                  hintText: 'Usuario logueado',
                  labelText: 'Usuario',
                )),
          ]),
          */
          Column(children: [
            TextFormField(
                controller: fecha,
                //enabled: carSel.id == -1 ? true : false,
                //readOnly: carSel.id != -1 ? true : false,
                onChanged: (value) {
                  carSel.fecha = value;
                },
                onTap: () async {
                  if (carSel.id == -1) {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                      carSel.fecha = formattedDate;
                      fecha.text = formattedDate;
                    }
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Fecha de la revision',
                  labelText: 'Fecha',
                )),
          ]),
          Column(children: [
            TextFormField(
                controller: maquina,
                //enabled: carSel.id == -1 ? true : false,
                //readOnly: carSel.id != -1 ? true : false,
                onChanged: (value) async {
                  carSel.maquina = value;
                  //update usuario field
                  usuario.text = authService.getUsername();
                  carSel.usuario = authService.getUsername();
                },
                decoration: const InputDecoration(
                  hintText: 'Maquina',
                  labelText: 'Maquina',
                )),
          ]),
          Column(children: [
            TextFormField(
                controller: local,
                onChanged: (value) {
                  carSel.local = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Local',
                  labelText: 'Local',
                )),
          ]),
          Column(children: [
            TextFormField(
                controller: repuesto,
                onChanged: (value) {
                  carSel.repuesto = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Repuesto',
                  labelText: 'Repuesto',
                )),
          ]),
          Column(children: [
            TextFormField(
                controller: observaciones,
                onChanged: (value) {
                  carSel.observaciones = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Observaciones',
                  labelText: 'Observaciones',
                )),
          ]),
          Column(children: [
            DropdownButtonFormField<String>(
              value: carSel.parada,
              decoration: InputDecoration(labelText: 'Parada'),
              items: statuses.map((status) {
                return DropdownMenuItem<String>(
                    value: status, child: Text(status));
              }).toList(),
              onChanged: (value) {
                parada = value;
                carSel.parada = value ?? "";
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
          ]),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(
                  width: 90,
                  child: Column(children: [
                    Image.network(carSel.foto1.isNotEmpty && carSel.foto1 != "-"
                        ? "http://192.168.0.105/projects/flutter_backend/${carSel.foto1}"
                        : placeholderImage),
                    TextButton(
                      child: const Text('Tomar Foto'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CameraScreen(
                                    ficha: c, fieldname: "foto1")));
                      },
                    ),
                  ]),
                ),
                SizedBox(width: 10),
                Container(
                  width: 90,
                  child: Column(children: [
                    Image.network(carSel.foto2.isNotEmpty && carSel.foto2 != "-"
                        ? "http://192.168.0.105/projects/flutter_backend/${carSel.foto2}"
                        : placeholderImage),
                    TextButton(
                      child: const Text('Tomar Foto'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CameraScreen(
                                    ficha: c, fieldname: "foto2")));
                      },
                    ),
                  ]),
                ),
                SizedBox(width: 10),
                Container(
                  width: 90,
                  child: Column(children: [
                    Image.network(carSel.foto3.isNotEmpty && carSel.foto3 != "-"
                        ? "http://192.168.0.105/projects/flutter_backend/${carSel.foto3}"
                        : placeholderImage),
                    TextButton(
                      child: const Text('Tomar Foto'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CameraScreen(
                                    ficha: c, fieldname: "foto3")));
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Column(children: [SizedBox(height: 100)]),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (!carService.isLoading) {
              FocusScope.of(context).requestFocus(FocusNode());
              Map<String, dynamic> f = await carService
                  .saveFicha(carSel.toMap()); //Guarda el ToDo actual

              carSel.id = int.parse(f["id"]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('SAVED!'),
                ),
              );
            }
          },
          child: carService.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
