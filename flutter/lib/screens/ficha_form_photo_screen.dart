import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

import 'package:fire_crud_mysql/models/ficha.dart';
import 'package:fire_crud_mysql/screens/screens.dart';
import 'package:fire_crud_mysql/providers/providers.dart';
import 'package:fire_crud_mysql/services/services.dart';

class CameraScreen extends StatefulWidget {
  static const String routerName = "CameraScreen";
  const CameraScreen({Key? key, required this.ficha, required this.fieldname})
      : super(key: key);
  final Ficha? ficha;
  final String fieldname;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  @override
  Widget build(BuildContext context) {
    Map f = widget.ficha!.toMap();

    final FichaService carService = Provider.of<FichaService>(context);

    return ChangeNotifierProvider(
      create: (_) => FichaFormProvider(carService.carSel),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Take a picture'),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 300,
                width: 400,
                child: controller == null
                    ? Center(child: Text("Loading Camera..."))
                    : !controller!.value.isInitialized
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CameraPreview(controller!),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  print("Ficha ID: ${f["id"]}");
                  try {
                    if (controller != null) {
                      if (controller!.value.isInitialized) {
                        image = await controller!.takePicture();
                        setState(() {});
                        Map<String, dynamic> r = await uploadImage(
                            File(image!.path), f["id"], widget.fieldname);

                        Ficha c = Ficha.fromMap(r);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FichaFormScreen(c: c)));
                      }
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                icon: Icon(Icons.camera),
                label: Text("Capture"),
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: image == null
                    ? Text("No image captured")
                    : Image.file(
                        File(image!.path),
                        height: 300,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadImage(File imageFile, int id, String fieldname) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "http://192.168.0.105/projects/flutter_backend/?route=upload&id=$id&fieldname=$fieldname"));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.headers.addAll({'Content-Type': 'multipart/form-data'});

    var response = await http.Client().send(request);
    print("RESPOMSE ${response}");
    var body = await response.stream.bytesToString();
    print('BODY: $body');

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed');
    }
    return jsonDecode(body);
  }
}
