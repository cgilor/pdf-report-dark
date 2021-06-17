import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_reports_dark/api/pdf_api.dart';
import 'package:pdf_reports_dark/api/pdf_api_report.dart';
import 'package:pdf_reports_dark/models/imgaPdf.dart';
import 'package:pdf_reports_dark/models/pdfInfo.dart';
import 'package:pdf_reports_dark/models/pdfReport.dart';

import 'package:pdf_reports_dark/providers/db_provider.dart';

class NewReportPage extends StatefulWidget {
  @override
  _NewReportPageState createState() => _NewReportPageState();
}

class _NewReportPageState extends State<NewReportPage> {
  late List<ImagePdf> photos = [];
  late ImagePdf fotos;
  PdfInfo pdfreport = new PdfInfo();
  bool isLoading = false;
  TextEditingController namePdfCtrl = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    refreshPhotos();
  }

  @override
  void dispose() {
    //PdfDatabase.instance.close();

    super.dispose();
  }

  Future refreshPhotos() async {
    setState(() => isLoading = true);

    this.photos = await PdfDatabase.instance.readAllImages();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('New Report', style: TextStyle(color: Colors.white70))),
        actions: [
          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () async {
                if (isLoading) return;
                await Navigator.pushNamed(context, 'photo');
                refreshPhotos();
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Form(key: formKey, child: _nameReport()),
              SizedBox(height: 20.0),
              SizedBox(height: 580.0, child: obtenerFotos(context)),
              // _crearBoton()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.lightBlue[800],
        child: Icon(
          Icons.save,
          color: Colors.white,
        ),
        onPressed: () {
          _sumit();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _nameReport() {
    return TextFormField(
      controller: namePdfCtrl,
      //initialValue: pdfreport.name,
      decoration: new InputDecoration(
          labelText: 'Name new report', icon: Icon(Icons.picture_as_pdf_sharp)),
      // onSaved: (value) => pdfreport.name = value!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Add name of report';
        } else {
          return null;
        }
      },
    );
  }

  Widget obtenerFotos(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, i) {
        return _buildRow(photos[i]);
      },
    );
  }

  Widget _buildRow(ImagePdf photo) {
    final foto = photo.path;
    final image = FileImage(
      File(foto!),
    );
    //print(image);
    return GestureDetector(
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Icon(Icons.delete_forever),
        ),
        onDismissed: (DismissDirection direction) async {
          final dir = Directory(photo.path!);
          dir.deleteSync(recursive: true);
          await PdfDatabase.instance.delete(photo.id!);

          await refreshPhotos();

          //await eliminarFoto();
        },
        child: Column(
          children: [
            Container(
              height: 150,
              width: 300,
              child: Image(image: image),
            ),
            ListTile(
              title: new Text(
                photo.description!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        if (isLoading) return;
        await Navigator.pushNamed(context, 'photo', arguments: photo);
        refreshPhotos();
      },
    );
  }

  void _sumit() async {
    if (formKey.currentState!.validate()) {
      await recorrerFotos();
      await eliminarFoto();
      await guardarPdf();

      formKey.currentState!.reset();

      //
    }
  }

  recorrerFotos() async {
    final data = await PdfDatabase.instance.readAllImages();
    data.forEach((element) async {
      final report = PdfReport(
          imageReport: ImagePdf(
            path: element.path,
            description: element.description,
          ),
          pdfinfo: PdfInfo(name: namePdfCtrl.text));
      final pdfFile = await PdfReportApi.generate(report);
      PdfApi.openFile(pdfFile);
    });
  }

  eliminarFoto() async {
    await PdfDatabase.instance.deleteAllScans();
    refreshPhotos();
  }

  guardarPdf() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = dir.path;
    final now = new DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd').format(now); // 28/03/2020
    final reportPdf =
        new PdfInfo(name: namePdfCtrl.text, path: file, createdTime: formatter);
    await PdfDatabase.instance.createPdf(reportPdf);
  }
}
