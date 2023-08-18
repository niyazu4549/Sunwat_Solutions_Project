import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sunwat_solutions/common_functions.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/controllers/service_calls.dart';
import 'package:sunwat_solutions/models/final_report_model.dart';

// ignore: must_be_immutable
class FinalReportScreen extends StatefulWidget {
  String reportId;

  FinalReportScreen({super.key, required this.reportId});

  @override
  State<FinalReportScreen> createState() => _FinalReportScreenState();
}

class _FinalReportScreenState extends State<FinalReportScreen> {
  ServiceCall serviceCall = ServiceCall();

  Future<FinalReportModel?> authViewButton() async {
    FinalReportModel? finalReportModel;
    Map<String, dynamic> reqObject = {
      "report_id": widget.reportId,
    };
    Response? response = await serviceCall.viewButton(
        context: context, map: reqObject, url: finalReportUrl);
    if (response != null &&
        response.statusCode == 200 &&
        response.body.toString().isNotEmpty) {
      print('final report= ${response.body}');
      // responseExtractedMap = json.decode(response.body);
      finalReportModel = finalReportModelFromJson(response.body);
      print('final report= ${finalReportModel}');
    }
    return finalReportModel;
  }

  @override
  Widget build(BuildContext context) {
    print('widget.reportId=${widget.reportId}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: authViewButton(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              FinalReportModel finalReportModel = snapshot.data!;
              if (finalReportModel.plants.data.isNotEmpty) {
                int index = 0;
                var seen = Set<int>();
                List<Serviceslist> list =
                    finalReportModel.plants.data[0].serviceslist;
                List<Serviceslist> uniqueServiceList = list
                    .where((model) => seen.add(int.parse(model.id)))
                    .toList();
                uniqueServiceList.sort((a, b) =>
                    int.parse(a.id.toString().trim())
                        .compareTo(int.parse(b.id.toString().trim())));
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                height: 70,
                                width: 70,
                                child: Image.asset('assets/images/logo.png'),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 30),
                                alignment: Alignment.center,
                                child: Text(
                                  'RO PLANT REPORT',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: ubuntu),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Report Id:  ${finalReportModel.plants.data[index].reportId}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: ubuntu),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Plant Name:  ${finalReportModel.plants.data[index].reportName}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: ubuntu),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Plant Address:  ${finalReportModel.plants.data[index].plantAddress}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: ubuntu),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Service List:',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: ubuntu),
                          ),
                        ),
                        for (int a = 0; a < uniqueServiceList.length; a++)
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    uniqueServiceList[a].id,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: ubuntu),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      uniqueServiceList[a].title,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: ubuntu),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 5,
                                  ),
                                  child: Text(
                                    uniqueServiceList[a].status == "false"
                                        ? "No"
                                        : "Yes",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: ubuntu),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Remarks:  ${finalReportModel.plants.data[index].remarks}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: ubuntu),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Selected Image:',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: ubuntu),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                finalReportModel.plants.data[0].plantimg.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${finalReportModel.plants.data[0].plantimg[index]}',
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "Customer Name: ${finalReportModel.plants.data[0].custName}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: ubuntu,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Text(
                                            'Customer Signature:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: ubuntu),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            'I/We Hereby Certify That The RO Plant\nreport Taken By Sunwat Solutions PVT\nDate On ${finalReportModel.plants.data[index].dateTime}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: ubuntu),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: loadNetworkImage(
                                              finalReportModel
                                                  .plants.data[index].cusSign),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "Executive Name: ${finalReportModel.plants.data[0].execName}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: ubuntu,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Text(
                                            'Executive Signature:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: ubuntu),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            'I/We Hereby Certify That The RO Plant\nreport Taken By Sunwat Solutions PVT\nDate On ${finalReportModel.plants.data[index].dateTime}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: ubuntu),
                                          ),
                                        ),
                                        Container(
                                          child: loadNetworkImage(
                                              finalReportModel
                                                  .plants.data[index].execSign),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   child: Text(
                        //     'Plant Report On Date:  ${finalReportModel.plants.data[index].dateTime}',
                        //     style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 14,
                        //         fontFamily: ubuntu),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            } else {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Text('Unable to fetch the data');
              }
            }
          }),
    );
  }
}
