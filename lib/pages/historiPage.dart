import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf_reports_dark/models/pdfInfo.dart';
import 'package:pdf_reports_dark/providers/db_provider.dart';
import 'package:pdf_reports_dark/utils/mostrar_alerta.dart';
import 'package:share_plus/share_plus.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
          appBar: AppBar(
            title: Text('My Reports'),
            actions: [],
          ),
          body: FutureBuilder(
              future: PdfDatabase.instance.readAllReports(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PdfInfo>> snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (_, i) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Text('Move to trash',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        key: ValueKey<int>(data[i].id!),
                        confirmDismiss: (DismissDirection direction) async {
                          if (Platform.isAndroid) {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Delete Confirmation"),
                                  content: const Text(
                                      "Are you sure you want to delete this item?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Delete")),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Cancel"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return await showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Delete Confirmation'),
                                    content: const Text(
                                        "Are you sure you want to delete this item?"),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        // isDefaultAction: true,
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Delete"),
                                      ),
                                      CupertinoDialogAction(
                                        // isDefaultAction: true,
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        onDismissed: (DismissDirection direction) async {
                          await PdfDatabase.instance.deleteReport(data[i].id!);
                          final dir = Directory(data[i].path.toString() +
                              '/' +
                              data[i].name.toString() +
                              '.pdf');
                          //print(dir);
                          dir.deleteSync(recursive: true);

                          setState(() {
                            data.remove(data[i]);
                          });
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.picture_as_pdf_outlined,
                            color: Colors.redAccent,
                          ),
                          title: Text(data[i].name!),
                          subtitle: Text(data[i].createdTime.toString()),
                          trailing: IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                final dir =
                                    '${data[i].path}/${data[i].name}.pdf';
                                Share.shareFiles(['$dir']);
                              }),
                          onTap: () async {
                            final dir = '${data[i].path}/${data[i].name}.pdf';
                            print(dir);
                            await OpenFile.open(dir);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
