// To parse this JSON data, do
//
//     final forgetPassword = forgetPasswordFromJson(jsonString);

import 'dart:convert';

ForgetPassword forgetPasswordFromJson(String str) =>
    ForgetPassword.fromJson(json.decode(str));

String forgetPasswordToJson(ForgetPassword data) => json.encode(data.toJson());

class ForgetPassword {
  bool status;
  String message;
  int password;

  ForgetPassword({
    required this.status,
    required this.message,
    required this.password,
  });

  factory ForgetPassword.fromJson(Map<String, dynamic> json) => ForgetPassword(
        status: json["status"],
        message: json["message"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "password": password,
      };
}
