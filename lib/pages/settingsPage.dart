import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_reports_dark/models/settings.dart';
import 'package:pdf_reports_dark/providers/db_provider.dart';
import 'package:pdf_reports_dark/providers/th_provider.dart';
import 'package:pdf_reports_dark/utils/mostrar_alerta.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<FormState> keyForm = new GlobalKey();

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  File? newImage;
  SettingsModel settings = new SettingsModel();

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Settings', style: TextStyle(color: Colors.white70))),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
          IconButton(
              icon: Icon(Icons.brightness_4),
              onPressed: () {
                _themeProvider.setTheme(_themeProvider.getTheme == lightTheme
                    ? darkTheme
                    : lightTheme);
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              _mostrarFoto(),
              Form(key: keyForm, child: formUI()),
              Container(
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.lightBlue[800],
                  child: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    save(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: ListTile(leading: Icon(icon), title: item),
    );
  }

  Widget formUI() {
    return Column(
      children: [
        formItemsDesign(
            Icons.person,
            TextFormField(
              initialValue: settings.name,
              decoration: new InputDecoration(
                labelText: 'Name',
              ),
              onSaved: (value) async => settings.name = value,
              validator: (value) {
                if (value!.isEmpty) {
                  return validateName.toString();
                } else {
                  return null;
                }
              },
            )),
        formItemsDesign(
            Icons.location_city,
            TextFormField(
              decoration: new InputDecoration(
                labelText: 'Address',
              ),
              onSaved: (value) => settings.address = value,
              validator: (value) {
                if (value!.isEmpty) {
                  return validateName.toString();
                } else {
                  return null;
                }
              },
            )),
        formItemsDesign(
            Icons.phone,
            TextFormField(
              decoration: new InputDecoration(
                labelText: 'Phone',
              ),
              onSaved: (value) => settings.phone = value,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value!.isEmpty) {
                  return validateMobile.toString();
                } else {
                  return null;
                }
              },
            )),
        formItemsDesign(
            Icons.email,
            TextFormField(
              decoration: new InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              maxLength: 32,
              onSaved: (value) => settings.email = value,
              validator: (value) {
                if (value!.isEmpty) {
                  return validateEmail.toString();
                } else {
                  return null;
                }
              },
            )),
      ],
    );
  }

  String? validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El nombre es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
    return null;
  }

  String? validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "El telefono es necesariod";
    } else if (!regExp.hasMatch(value) || value.length != 10) {
      return "El numero debe tener 10 digitos";
    }
    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El correo es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "Correo invalido";
    } else {
      return null;
    }
  }

  Widget _mostrarFoto() {
    // ignore: unnecessary_null_comparison
    if (_imageFile == null) {
      return ClipOval(
        child: Image(
          image: AssetImage('assets/no-image.png'),
          fit: BoxFit.cover,
          width: 150,
          height: 150,
        ),
      );
    } else {
      return ClipOval(
        child: Image(
          image: FileImage(File(_imageFile!.path)),
          fit: BoxFit.cover,
          width: 150,
          height: 150,
        ),
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final pickedFile = await _picker.getImage(source: origen);
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(pickedFile!.path);
    final imageFile = File('${directory.path}/$name');
    newImage = await File(pickedFile.path).copy(imageFile.path);

    try {
      _imageFile = File(pickedFile.path);
    } catch (e) {
      print(e);
    }
    if (_imageFile != null) {
      settings.image = null;
    }

    setState(() {});
  }

  save(context) async {
    final data = await PdfDatabase.instance.readAllSett();
    if (newImage != null) {
      //mostrarAlerta(context, 'Image', 'Insert image');
      //return;
      settings.image = newImage!.path;
    }

    if (keyForm.currentState!.validate()) {
      keyForm.currentState!.save();
      if (data.isEmpty) {
        await PdfDatabase.instance.createSett(settings);
      } else {
        settings.id = 1;
        await PdfDatabase.instance.updateSett(settings);
      }
      print(settings.name);
      keyForm.currentState!.reset();

      //Navigator.pop(context, 'home');
    }
  }
}
