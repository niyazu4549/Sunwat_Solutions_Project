// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool status;
  String message;
  List<Datum> data;

  LoginModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String name;
  String username;
  String password;
  dynamic dob;
  dynamic address;
  String status;
  String role;
  dynamic lastlogin;
  dynamic pid;

  Datum({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    this.dob,
    this.address,
    required this.status,
    required this.role,
    this.lastlogin,
    this.pid,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"] ?? '',
    username: json["username"],
    password: json["password"],
    dob: json["dob"] ?? '',
    address: json["address"],
    status: json["status"],
    role: json["role"],
    lastlogin: json["lastlogin"],
    pid: json["pid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name ?? '',
    "username": username,
    "password": password,
    "dob": dob ?? '',
    "address": address,
    "status": status,
    "role": role,
    "lastlogin": lastlogin,
    "pid": pid,
  };
}
