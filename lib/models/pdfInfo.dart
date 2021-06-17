// To parse this JSON data, do
//
//     final pdfReport = pdfReportFromJson(jsonString);

import 'dart:convert';

PdfInfo pdfReportFromJson(String str) => PdfInfo.fromJson(json.decode(str));

String pdfReportToJson(PdfInfo data) => json.encode(data.toJson());

class PdfInfo {
  PdfInfo({this.id, this.path, this.name, this.createdTime});

  int? id;
  String? path;
  String? name;
  String? createdTime;

  PdfInfo copy({
    int? id,
    String? path,
    String? name,
    String? createdTime,
  }) =>
      PdfInfo(
        id: id ?? this.id,
        path: path ?? this.path,
        name: name ?? this.name,
        createdTime: createdTime ?? this.createdTime,
      );

  factory PdfInfo.fromJson(Map<String, dynamic> json) => PdfInfo(
      id: json["id"],
      path: json["path"],
      name: json["name"],
      createdTime: json['time']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "path": path,
        "name": name,
        "time": createdTime,
      };
}
