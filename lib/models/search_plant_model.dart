// To parse this JSON data, do
//
//     final searchPlantModel = searchPlantModelFromJson(jsonString);

import 'dart:convert';

SearchPlantModel searchPlantModelFromJson(String str) =>
    SearchPlantModel.fromJson(json.decode(str));

String searchPlantModelToJson(SearchPlantModel data) =>
    json.encode(data.toJson());

class SearchPlantModel {
  Plants plants;

  SearchPlantModel({
    required this.plants,
  });

  factory SearchPlantModel.fromJson(Map<String, dynamic> json) =>
      SearchPlantModel(
        plants: Plants.fromJson(json["Plants"]),
      );

  Map<String, dynamic> toJson() => {
        "Plants": plants.toJson(),
      };
}

class Plants {
  bool status;
  List<Datum> data;

  Plants({
    required this.status,
    required this.data,
  });

  factory Plants.fromJson(Map<String, dynamic> json) => Plants(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
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
