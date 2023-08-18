// To parse this JSON data, do
//
//     final plantsModel = plantsModelFromJson(jsonString);

import 'dart:convert';

PlantsModel plantsModelFromJson(String str) =>
    PlantsModel.fromJson(json.decode(str));

String plantsModelToJson(PlantsModel data) => json.encode(data.toJson());

class PlantsModel {
  bool status;
  List<Datum> data;
  int totalRecords;

  PlantsModel({
    required this.status,
    required this.data,
    required this.totalRecords,
  });

  factory PlantsModel.fromJson(Map<String, dynamic> json) => PlantsModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        totalRecords: json["total_records"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total_records": totalRecords,
      };
}

class Datum {
  String plantId;
  String plantName;

  Datum({
    required this.plantId,
    required this.plantName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        plantId: json["plant_id"],
        plantName: json["plantName"],
      );

  Map<String, dynamic> toJson() => {
        "plant_id": plantId,
        "plantName": plantName,
      };
}
