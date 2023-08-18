// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  bool status;
  List<Datum> data;
  int totalRecords;

  ReportModel({
    required this.status,
    required this.data,
    required this.totalRecords,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
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
  String plantId;
  String userId;
  String assignId;
  dynamic remarks;
  dynamic cusSign;
  dynamic execSign;
  DateTime dateTime;
  List<dynamic> images;
  List<Serviceslist> serviceslist;

  Datum({
    required this.reportId,
    required this.reportName,
    required this.plantId,
    required this.userId,
    required this.assignId,
    this.remarks,
    this.cusSign,
    this.execSign,
    required this.dateTime,
    required this.images,
    required this.serviceslist,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        reportId: json["report_id"],
        reportName: json["report_name"],
        plantId: json["plant_id"],
        userId: json["user_id"],
        assignId: json["assign_id"],
        remarks: json["remarks"],
        cusSign: json["cus_sign"],
        execSign: json["exec_sign"],
        dateTime: DateTime.parse(json["date_time"]),
        images: List<dynamic>.from(json["images"].map((x) => x)),
        serviceslist: List<Serviceslist>.from(
            json["serviceslist"].map((x) => Serviceslist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "report_id": reportId,
        "report_name": reportName,
        "plant_id": plantId,
        "user_id": userId,
        "assign_id": assignId,
        "remarks": remarks,
        "cus_sign": cusSign,
        "exec_sign": execSign,
        "date_time": dateTime.toIso8601String(),
        "images": List<dynamic>.from(images.map((x) => x)),
        "serviceslist": List<dynamic>.from(serviceslist.map((x) => x.toJson())),
      };
}

class Serviceslist {
  String serId;
  String status;

  Serviceslist({
    required this.serId,
    required this.status,
  });

  factory Serviceslist.fromJson(Map<String, dynamic> json) => Serviceslist(
        serId: json["ser_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "ser_id": serId,
        "status": status,
      };
}
