import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart' as pdfWid;
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:pdf_reports_dark/api/pdf_api.dart';
import 'package:pdf_reports_dark/models/costumer.dart';
import 'package:pdf_reports_dark/models/imgaPdf.dart';
import 'package:pdf_reports_dark/models/pdfReport.dart';
import 'package:pdf_reports_dark/models/settings.dart';
import 'package:pdf_reports_dark/providers/db_provider.dart';

class PdfReportApi {
  static Future<File> generate(PdfReport report) async {
    final pdf = pdfLib.Document();
    List<ImagePdf> dataDB = await PdfDatabase.instance.readAllImages();
    List<SettingsModel> dataSett = await PdfDatabase.instance.readAllSett();
    List<CostumerModel> costumerData =
        await PdfDatabase.instance.readAllCostumer();
    final now = new DateTime.now();
    final formatter = DateFormat('yyy-MM-dd').format(
        now); //final font = await rootBundle.load('assets/OpenSans-Light.ttf');
    // final ttf = pdfLib.Font.ttf(font);

    pdf.addPage(pdfLib.MultiPage(
        build: (context) => [
              pdfLib.Column(
                  crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                  children: [
                    pdfLib.SizedBox(height: 1 * pdfWid.PdfPageFormat.cm),
                    pdfLib.Row(
                        mainAxisAlignment:
                            pdfLib.MainAxisAlignment.spaceBetween,
                        children: [
                          pdfLib.Column(
                            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                            children: dataSett.map((e) {
                              return pdfLib.Column(
                                  crossAxisAlignment:
                                      pdfLib.CrossAxisAlignment.start,
                                  children: [
                                    pdfLib.Text(e.name!,
                                        style: pdfLib.TextStyle(
                                            fontWeight: pdfLib.FontWeight.bold,
                                            fontSize: 15)),
                                    pdfLib.SizedBox(
                                        height: 1 * pdfWid.PdfPageFormat.mm),
                                    //   if (report.settingsModel != null)
                                    pdfLib.Text(e.address!,
                                        style: pdfLib.TextStyle(
                                            fontWeight:
                                                pdfLib.FontWeight.normal)),
                                    pdfLib.SizedBox(
                                        height: 1 * pdfWid.PdfPageFormat.mm),
                                    //   if (report.settingsModel != null)
                                    pdfLib.Text(e.phone!,
                                        style: pdfLib.TextStyle(
                                            fontWeight:
                                                pdfLib.FontWeight.normal)),
                                    pdfLib.SizedBox(
                                        height: 1 * pdfWid.PdfPageFormat.mm),
                                    //  if (report.settingsModel != null)
                                    pdfLib.Text(e.email!,
                                        style: pdfLib.TextStyle(
                                            fontWeight:
                                                pdfLib.FontWeight.normal)),
                                  ]);
                            }).toList(),
                          ),
                          pdfLib.Column(
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: dataSett.map((e) {
                                return pdfLib.Column(
                                    crossAxisAlignment:
                                        pdfLib.CrossAxisAlignment.start,
                                    children: [
                                      pdfLib.Container(
                                        height: 100,
                                        width: 100,
                                        child: pdfLib.Image(pdfLib.MemoryImage(
                                            File(e.image!).readAsBytesSync())),
                                      ),
                                    ]);
                              }).toList()),
                        ]),
                    pdfLib.SizedBox(height: 1 * pdfWid.PdfPageFormat.cm),
                    pdfLib.Row(
                        crossAxisAlignment: pdfLib.CrossAxisAlignment.end,
                        mainAxisAlignment:
                            pdfLib.MainAxisAlignment.spaceBetween,
                        children: [
                          // buildSupplierAddress(report),
                          pdfLib.Column(
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: costumerData.map((e) {
                                return pdfLib.Column(children: [
                                  pdfLib.Text('Costumer: ',
                                      style: pdfLib.TextStyle(
                                          fontWeight: pdfLib.FontWeight.bold,
                                          fontSize: 15)),
                                  pdfLib.Text(e.name!,
                                      style: pdfLib.TextStyle(
                                          fontWeight: pdfLib.FontWeight.normal,
                                          fontSize: 15)),
                                  pdfLib.Text(e.address!,
                                      style: pdfLib.TextStyle(
                                          fontWeight: pdfLib.FontWeight.normal,
                                          fontSize: 15)),
                                ]);
                              }).toList()),
                          pdfLib.Text('date: ' + formatter,
                              style: pdfLib.TextStyle(
                                  fontWeight: pdfLib.FontWeight.bold,
                                  fontSize: 15)),
                        ])
                  ]),
              //pdfLib.SizedBox(height: 3 * pdfWid.PdfPageFormat.cm),
              pdfLib.Divider(),
              pdfLib.Column(
                children: dataDB.map((e) {
                  return pdfLib.Column(
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.SizedBox(height: 15.0),
                      pdfLib.Row(
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                          mainAxisAlignment:
                              pdfLib.MainAxisAlignment.spaceBetween,
                          children: [
                            pdfLib.Container(
                              width: 210,
                              height: 500,
                              child: pdfLib.Image(pdfLib.MemoryImage(
                                  File(e.path!).readAsBytesSync())),
                            ),
                            pdfLib.SizedBox(width: 40.0),

                            pdfLib.Text('${e.description!}\n\n',
                                textAlign: pdfLib.TextAlign.justify,
                                style: pdfLib.TextStyle(
                                    fontWeight: pdfLib.FontWeight.normal,
                                    height: 1.4,
                                    fontSize: 20)),

                            /*  pdfLib.Text(e.description!,
                                style: pdfLib.TextStyle(
                                    fontWeight: pdfLib.FontWeight.normal,
                                    fontSize: 20)),*/
                            // buildLogoSupplier(invoice.supplier),Extraer logo

                            //
                          ]),
                      // pdfLib.Text(e.createdTime.toIso8601String())
                    ],
                  );
                }).toList(),
              )
            ]));

    return PdfApi.saveDocument(
        name: '${report.pdfinfo!.name}' + '.pdf', pdf: pdf);
  }

  static buildLogoSupplier(PdfReport report) {
    if (report.settingsModel != null) {
      final foto = report.settingsModel!.image.toString();
      final image = pdfLib.MemoryImage(
        File('$foto').readAsBytesSync(),
      );

      return pdfLib.Container(
        height: 150,
        width: 150,
        child: pdfLib.Image(image),
      );
    }
  }

  static buildSupplierAddress(PdfReport report) {
    return FutureBuilder(
        future: PdfDatabase.instance.readAllCostumer(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CostumerModel>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(report.costumerModel!.name!,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
