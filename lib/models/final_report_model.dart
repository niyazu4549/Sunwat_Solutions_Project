// To parse this JSON data, do
//
//     final finalReportModel = finalReportModelFromJson(jsonString);

import 'dart:convert';

FinalReportModel finalReportModelFromJson(String str) =>
    FinalReportModel.fromJson(json.decode(str));

String finalReportModelToJson(FinalReportModel data) =>
    json.encode(data.toJson());

class FinalReportModel {
  Plants plants;

  FinalReportModel({
    required this.plants,
  });

  factory FinalReportModel.fromJson(Map<String, dynamic> json) =>
      FinalReportModel(
        plants: Plants.fromJson(json["Plants"]),
      );

  Map<String, dynamic> toJson() => {
        "Plants": plants.toJson(),
      };
}

class Plants {
  bool status;
  List<Datum> data;
  String totalRecords;

  Plants({
    required this.status,
    required this.data,
    required this.totalRecords,
  });

  factory Plants.fromJson(Map<String, dynamic> json) => Plants(
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
  String reportId;
  String reportName;
  String execName;
  String custName;
  String plantId;
  String userId;
  String assignId;
  String remarks;
  String plantAddress;
  String cusSign;
  String execSign;
  DateTime dateTime;
  List<String> plantimg;
  List<Serviceslist> serviceslist;

  Datum({
    required this.reportId,
    required this.reportName,
    required this.execName,
    required this.custName,
    required this.plantId,
    required this.userId,
    required this.assignId,
    required this.remarks,
    required this.plantAddress,
    required this.cusSign,
    required this.execSign,
    required this.dateTime,
    required this.plantimg,
    required this.serviceslist,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        reportId: json["report_id"],
        reportName: json["report_name"],
        execName: json["exec_name"],
        custName: json["cust_name"],
        plantId: json["plant_id"],
        userId: json["user_id"],
        assignId: json["assign_id"],
        remarks: json["remarks"],
        plantAddress: json["plant_address"],
        cusSign: json["cus_sign"],
        execSign: json["exec_sign"],
        dateTime: DateTime.parse(json["date_time"]),
        plantimg: List<String>.from(json["plantimg"].map((x) => x)),
        serviceslist: List<Serviceslist>.from(
            json["serviceslist"].map((x) => Serviceslist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "report_id": reportId,
        "report_name": reportName,
        "exec_name": execName,
        "cust_name": custName,
        "plant_id": plantId,
        "user_id": userId,
        "assign_id": assignId,
        "remarks": remarks,
        "plant_address": plantAddress,
        "cus_sign": cusSign,
        "exec_sign": execSign,
        "date_time": dateTime.toIso8601String(),
        "plantimg": List<dynamic>.from(plantimg.map((x) => x)),
        "serviceslist": List<dynamic>.from(serviceslist.map((x) => x.toJson())),
      };
}

class Serviceslist {
  String id;
  String title;
  String status;

  Serviceslist({
    required this.id,
    required this.title,
    required this.status,
  });

  factory Serviceslist.fromJson(Map<String, dynamic> json) => Serviceslist(
        id: json["id"],
        title: json["title"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
      };
}
