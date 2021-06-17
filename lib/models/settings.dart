// To parse this JSON data, do
//
//     final settingsModel = settingsModelFromJson(jsonString);

import 'dart:convert';

SettingsModel settingsModelFromJson(String str) =>
    SettingsModel.fromJson(json.decode(str));

String settingsModelToJson(SettingsModel data) => json.encode(data.toJson());

class SettingsModel {
  SettingsModel(
      {this.id, this.name, this.address, this.phone, this.email, this.image});

  int? id;
  String? name;
  String? address;
  String? phone;
  String? email;
  String? image;

  SettingsModel copy({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? image,
  }) =>
      SettingsModel(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        image: image ?? this.image,
      );
  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "email": email,
        "image": image,
      };
}
