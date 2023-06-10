import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fire_crud_mysql/models/ficha.dart';
import 'package:fire_crud_mysql/screens/screens.dart';
import 'package:fire_crud_mysql/providers/providers.dart';
import 'package:fire_crud_mysql/services/services.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = "HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FichaService carService = Provider.of<FichaService>(context);

    return ChangeNotifierProvider(
      create: (_) => FichaFormProvider(carService.carSel),
      child: _CarBody(carService: carService),
    );
  }
}

class _CarBody extends StatelessWidget {
  final FichaService carService;
  const _CarBody({Key? key, required this.carService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserService>(context, listen: false);
    final List<String> statuses = ['R', 'S'];
    final carForm = Provider.of<FichaFormProvider>(context);
    Ficha carSel = carForm.ficha;
    String? filtroAceite;

    //Se agrega para poder editar el texto desde codigo
    var txtEditCrl = TextEditingController();

    const placeholderImage =
        'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Fichas'),
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
          child: ElevatedButton(
            child: const Text(' Nuevo+ '),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FichaFormScreen()),
              );
            },
          ),
        ),
        /*
        Center(
          child: ElevatedButton(
            child: const Text(' Reload '),
            onPressed: () {
              carService.getAll({});
            },
          ),
        ),
        */
        _RecordsListTableScreenState()
      ])),
    );
  }
}

class _RecordsListTableScreenState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FichaService carService = Provider.of<FichaService>(context);

    return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(children: [
          FutureBuilder(
            future: carService.getAll({}),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                //return Text('Error: \${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }

              var rows = [];
              final data = snapshot.data;
              print("SNAPSHOT $data");

              if (data is List && data.isNotEmpty) {
                rows = data;
              } else {
                return Text('No data found!');
              }

              if (data == null) {
                return Text('No data found!');
              }

              return DataTable(
                columns: [
                  DataColumn(label: Text('Maquina')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: rows.map((record) {
                  return DataRow(cells: [
                    DataCell(Text(record["maquina"] ?? "-")),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Edit action
                            record["id"] = record["id"] is int
                                ? record["id"]
                                : int.parse(record["id"]);
                            print("RECORD $record");
                            Ficha c = Ficha.fromMap(record);
                            print("FICHA $c");

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => FichaFormScreen(c: c)));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // Delete action
                            await carService
                                .deleteFicha(int.parse(record["id"]));
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              );
            },
          ),
        ]));
  }
}
