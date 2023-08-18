import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sunwat_solutions/background_locations_services/background_location_service.dart';
import 'package:sunwat_solutions/colors.dart';
import 'package:sunwat_solutions/common_functions.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/controllers/service_calls.dart';
import 'package:sunwat_solutions/models/logout_model.dart';
import 'package:sunwat_solutions/models/reports_model.dart';
import 'package:sunwat_solutions/views/final_report_screen.dart';
import 'package:sunwat_solutions/views/login_screen.dart';
import 'package:sunwat_solutions/views/search_plant_screen.dart';

class RoPlantReport extends StatefulWidget {
  RoPlantReport({Key? key}) : super(key: key);

  @override
  State<RoPlantReport> createState() => _RoPlantReportState();
}

class _RoPlantReportState extends State<RoPlantReport> {
  int itemCount = 3;
  ServiceCall serviceCall = ServiceCall();

  void requestFirebaseMessegingPermission()async {
    await backgroundService.initializeService();
    //Set service as foreground.(Notification will available till the service end)
    backgroundService.setServiceAsForeGround();
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<ReportModel?> authReport() async {
    ReportModel? reportModel;
    print('ConstantVariables.userId=${ConstantVariables.userId}');
    Response? response = await serviceCall.reports(
        context: context, url: '${reportUrl}${ConstantVariables.userId}');
    if (response != null &&
        response.statusCode == 200 &&
        response.body.toString().isNotEmpty) {
      print('response.body=${response.body}');
      reportModel = reportModelFromJson(response.body);
      print('reportModel= ${reportModel.data}');
    }
    return reportModel;
  }

  Future<LogOutModel?> authLogOut() async {
    LogOutModel? logOutModel;
    // print('ConstantVariables.userId=${ConstantVariables.userId}');
    Response? response =
        await serviceCall.logOut(context: context, url: logOutUrl, map: {
      "username": ConstantVariables.userName,
    });
    if (response != null &&
        response.statusCode == 200 &&
        response.body.toString().isNotEmpty) {
      clearSharedPreferences();
      print('response.body=${response.body}');
      logOutModel = logOutModelFromJson(response.body);
      print('logOutModel= ${logOutModel.message}');
    }
    return logOutModel;
  }
  @override
  void initState() {
    super.initState();
    requestFirebaseMessegingPermission();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        exit(0);
      },
      child: Scaffold(
        body: FutureBuilder(
            future: getUserInfoData(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          white,
                          white,
                          Colors.lightBlueAccent,
                          Colors.lightBlueAccent
                        ])),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //logo image and top text
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 26, bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //logo image
                                Container(
                                  margin: const EdgeInsets.only(right: 30),
                                  height: 70,
                                  width: 70,
                                  child: Image.asset(logo),
                                ),
                                //top text
                                Container(
                                  margin: const EdgeInsets.only(right: 28),
                                  child: Text(
                                    rOPlantReport,
                                    style: TextStyle(
                                        color: indigo,
                                        fontSize: 21,
                                        fontFamily: ubuntu,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                //logout button
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                    );
                                    authLogOut();
                                  },
                                  child: const Icon(
                                    Icons.power_settings_new_outlined,
                                    size: 24,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //text
                          Container(
                            margin: const EdgeInsets.only(
                                left: 30, right: 15, bottom: 5),
                            child: Text(
                              reportText1,
                              style: TextStyle(
                                  color: black, fontSize: 21, fontFamily: ubuntu),
                            ),
                          ),
                          //text
                          Container(
                            margin: const EdgeInsets.only(left: 30, bottom: 40),
                            child: Text(
                              reportText2,
                              style: TextStyle(
                                  color: black, fontSize: 21, fontFamily: ubuntu),
                            ),
                          ),
                          //RO plant report button
                          SizedBox(
                            height: 55,
                            width: 260,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: orange,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18))),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchPlantScreen()),
                                  );
                                },
                                child: Text(
                                  rOPlantReportButton,
                                  style: TextStyle(
                                      fontFamily: ubuntu,
                                      fontSize: 21,
                                      color: white),
                                ),
                              ),
                            ),
                          ),
                          //text
                          Container(
                            margin: const EdgeInsets.only(
                                left: 30, right: 15, bottom: 5, top: 20),
                            child: Text(
                              plantReportOnDate,
                              style: TextStyle(
                                  color: black, fontSize: 21, fontFamily: ubuntu),
                            ),
                          ),
                          //text
                          Container(
                            margin: const EdgeInsets.only(left: 30, bottom: 40),
                            child: Text(
                              byUser,
                              style: TextStyle(
                                  color: black, fontSize: 21, fontFamily: ubuntu),
                            ),
                          ),
                          //plant name report
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 15),
                            decoration: BoxDecoration(
                                border: Border.all(width: 2, color: indigo),
                                color: white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(18))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //header
                                Container(
                                  height: 45,
                                  width: double.infinity,
                                  // margin: const EdgeInsets.only(left: 20,right: 15),
                                  decoration: const BoxDecoration(
                                    color: indigo,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 12),
                                        child: Text(
                                          sNo,
                                          style: TextStyle(
                                              color: white,
                                              fontFamily: ubuntu,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          rOPlantName,
                                          style: TextStyle(
                                              color: white,
                                              fontFamily: ubuntu,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // plant table using listview builder
                                FutureBuilder(
                                    future: authReport(),
                                    builder: (context, snapshot) {
                                      print(snapshot.data);
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        int count = 0;
                                        ReportModel reportModel = snapshot.data!;
                                        reportModel.data =
                                            reportModel.data.reversed.toList();
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemCount:
                                                reportModel.data.length >= 10
                                                    ? 10
                                                    : reportModel.data.length,
                                            itemBuilder: (context, index) {
                                              bool reportNameExist = snapshot
                                                  .data!.data[index].reportName
                                                  .toString()
                                                  .isNotEmpty;
                                              if (reportNameExist) {
                                                count++;
                                              }
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (reportNameExist)
                                                    IntrinsicHeight(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            child: Center(
                                                              child: Text(
                                                                "${count}",
                                                                style: TextStyle(
                                                                    color: black,
                                                                    fontSize: 17,
                                                                    fontFamily:
                                                                        ubuntu),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 2,
                                                            color: indigo,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 5,
                                                                      top: 5,
                                                                      bottom: 5),
                                                              child: Text(
                                                                "${reportModel.data[index].reportName}",
                                                                style: TextStyle(
                                                                    color: black,
                                                                    fontFamily:
                                                                        ubuntu,
                                                                    fontSize: 14),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 2,
                                                            color: indigo,
                                                          ),
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    right: 5,
                                                                    top: 5,
                                                                    bottom: 5),
                                                            height: 16,
                                                            width: 60,
                                                            child: ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: indigo,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(
                                                                                8))),
                                                              ),
                                                              onPressed: () {
                                                                print(
                                                                    'report id=${reportModel.data[index].reportId}');
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => FinalReportScreen(
                                                                          reportId: reportModel
                                                                              .data[index]
                                                                              .reportId)),
                                                                );
                                                              },
                                                              child: Text(
                                                                vieWButton,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        ubuntu,
                                                                    fontSize: 12,
                                                                    color: white),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  Visibility(
                                                    visible: ((index + 1) !=
                                                            snapshot.data!.data
                                                                .length &&
                                                        snapshot.data!.data[index]
                                                            .reportName
                                                            .toString()
                                                            .isNotEmpty),
                                                    child: Container(
                                                      color: indigo,
                                                      height: 2,
                                                    ),
                                                  )
                                                ],
                                              );
                                            });
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return const Text(
                                            'Something went wrong pls try agin');
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Text('Unable to fetch the data');
              }
            }),
      ),
    );
  }
}
