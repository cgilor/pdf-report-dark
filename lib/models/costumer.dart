// To parse this JSON data, do
//
//     final costumerModel = costumerModelFromJson(jsonString);

import 'dart:convert';

CostumerModel costumerModelFromJson(String str) =>
    CostumerModel.fromJson(json.decode(str));

String costumerModelToJson(CostumerModel data) => json.encode(data.toJson());

class CostumerModel {
  CostumerModel({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.email,
  });

  int? id;
  String? name;
  String? address;
  String? phone;
  String? email;

  CostumerModel copy(
          {int? id,
          String? name,
          String? address,
          String? phone,
          String? email}) =>
      CostumerModel(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        email: email ?? this.email,
      );

  factory CostumerModel.fromJson(Map<String, dynamic> json) => CostumerModel(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "email": email,
      };
}
