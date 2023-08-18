import 'dart:convert';

ServiceListModel ServiceListModelFromJson(String str) =>
    ServiceListModel.fromJson(json.decode(str));

String ServiceListModelToJson(ServiceListModel data) =>
    json.encode(data.toJson());

class ServiceListModel {
  List<Datum> data;
  int totalRecords;

  ServiceListModel({
    required this.data,
    required this.totalRecords,
  });

  factory ServiceListModel.fromJson(Map<String, dynamic> json) =>
      ServiceListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        totalRecords: json["total_records"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total_records": totalRecords,
      };
}

class Datum {
  String id;
  String sName;
  String priority;
  DateTime cDate;

  Datum({
    required this.id,
    required this.sName,
    required this.priority,
    required this.cDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        sName: json["s_name"],
        priority: json["priority"],
        cDate: DateTime.parse(json["c_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "s_name": sName,
        "priority": priority,
        "c_date": cDate.toIso8601String(),
      };
}
