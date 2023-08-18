import 'dart:convert';

LocationModel LocationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String LocationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  bool status;
  String message;

  LocationModel({
    required this.status,
    required this.message,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
