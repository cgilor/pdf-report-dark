import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_reports_dark/models/imgaPdf.dart';
import 'package:pdf_reports_dark/providers/db_provider.dart';

class PhotoReport extends StatefulWidget {
  @override
  _PhotoReportState createState() => _PhotoReportState();
}

class _PhotoReportState extends State<PhotoReport> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController descriptionCtrl = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  ImagePdf fotos = new ImagePdf();
  @override
  Widget build(BuildContext context) {
    final ImagePdf? fotoData =
        ModalRoute.of(context)!.settings.arguments as ImagePdf?;
    if (fotoData != null) {
      fotos = fotoData;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Images'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                SizedBox(
                  height: 15,
                ),
                _crearNombre(),
                _crearBoton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: fotos.description,
      maxLines: 3,
      //controller: descriptionCtrl,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Description'),
      onSaved: (value) => fotos.description = value,
      validator: (value) {
        if (value!.length < 3) {
          return 'Name';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearBoton(BuildContext context) {
    return ElevatedButton.icon(
      label: Text('Save'),
      icon: Icon(Icons.save),
      onPressed: () {
        _submit(context);
      },
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ))),
    );
  }

  void _submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    save();
    formKey.currentState!.save();

    Navigator.pop(context);
  }

  Widget _mostrarFoto() {
    // ignore: unnecessary_null_comparison

    if (fotos.path != null) {
      return Image(
        image: FileImage(File(fotos.path!)),
        fit: BoxFit.cover,
        height: 300.0,
      );
    } else {
      if (_imageFile != null) {
        return Image(
          image: FileImage(File(_imageFile!.path)),
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
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

    try {
      _imageFile = PickedFile(pickedFile!.path);
    } catch (e) {
      print(e);
    }
    if (_imageFile != null) {
      fotos.path = null;
    }

    setState(() {});
  }

  void save() async {
    if (fotos.path == null) {
      fotos.path = _imageFile!.path;
    } else {
      fotos.path = fotos.path;
    }

    print(fotos.path);
    if (fotos.id == null) {
      await PdfDatabase.instance.create(fotos);
    } else {
      await PdfDatabase.instance.update(fotos);
    }
  }
}
