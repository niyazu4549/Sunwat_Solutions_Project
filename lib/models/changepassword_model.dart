// To parse this JSON data, do
//
//     final changePassword = changePasswordFromJson(jsonString);

import 'dart:convert';

ChangePassword changePasswordFromJson(String str) =>
    ChangePassword.fromJson(json.decode(str));

String changePasswordToJson(ChangePassword data) => json.encode(data.toJson());

class ChangePassword {
  bool status;
  String message;

  ChangePassword({
    required this.status,
    required this.message,
  });

  factory ChangePassword.fromJson(Map<String, dynamic> json) => ChangePassword(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
