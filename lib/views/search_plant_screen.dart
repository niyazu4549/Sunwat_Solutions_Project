import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core' as core;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sunwat_solutions/background_locations_services/background_location_service.dart';
import 'package:sunwat_solutions/colors.dart';
import 'package:sunwat_solutions/common_functions.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/controllers/service_calls.dart';
import 'package:sunwat_solutions/models/login_model.dart';
import 'package:sunwat_solutions/models/search_plant_model.dart';
import 'package:sunwat_solutions/models/services_list_model.dart';
import 'package:sunwat_solutions/views/inner_list_screen.dart';
import 'package:sunwat_solutions/views/provider_class.dart';
import 'package:sunwat_solutions/views/ro_plant_report.dart';
import 'package:sunwat_solutions/views/ro_plant_report_screen.dart';
import 'package:sunwat_solutions/models/service_lists_model.dart';

class SearchPlantScreen extends StatefulWidget {
  const SearchPlantScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlantScreen> createState() => _SearchPlantScreenState();
}

class _SearchPlantScreenState extends State<SearchPlantScreen> {
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantAddressController = TextEditingController();
  ServiceCall serviceCall = ServiceCall();
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;

  Future<Map<String, dynamic>?> authNextButton() async {
    Map<String, dynamic> responseExtractedMap = {};
    list.forEach((element) {
      Map<String, dynamic> insertServiceMap = {
        "id": element.id,
        "title": element.text,
        "status": element.status
      };
      ConstantVariables.serviceListDataArray.add(insertServiceMap);
    });
    print(
        'ConstantVariables.serviceListDataArray=${ConstantVariables.serviceListDataArray}');
    Response? response = await serviceCall.nextButton(
        context: context, map: requestPayloadMap, url: savedataUrl);
    if (response != null &&
        response.statusCode == 200 &&
        response.body.toString().isNotEmpty) {
      print('Api test= ${response.body}');
      responseExtractedMap = json.decode(response.body);
    } else {
      Navigator.pop(context);
      displayToastMessage(message: 'unable to fetch the data from server');
    }
    return responseExtractedMap;
  }

  void _nextButton() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    showAlertDialog(context, 'please wait', 'loading..');
    Map<String, dynamic>? mapBody = await authNextButton();
    if (mapBody != null &&
        mapBody.isNotEmpty &&
        mapBody.containsKey('message') &&
        mapBody['message'] != null &&
        mapBody.containsKey('report_id') &&
        mapBody['report_id'] != null) {
      print('return response printed=${mapBody}');
      ConstantVariables.reportId = mapBody['report_id'].toString().trim();
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const RoPlantReportScreen()));
    }
    // print(requestPayloadMap);
  }

  // search plant API
  Future<SearchPlantModel?> authSearchPlant() async {
    SearchPlantModel? searchPlant;
    Map<String, dynamic> map = {
      "plantname": _plantNameController.text.toString().trim(),
    };
    Response? response = await serviceCall.searchPlant(
        context: context, map: map, url: searchPlantUrl);
    if (response != null &&
        response.statusCode == 200 &&
        response.body.toString().isNotEmpty) {
      searchPlant = searchPlantModelFromJson(response.body);
    }
    return searchPlant;
  }

  Future<dynamic> plantName(String) async {
    List<dynamic> list = [];
    Response? response =
        await serviceCall.plantName(context: context, url: plantUrl);
    if (response != null &&
        response.statusCode == 200 &&
        response.body.toString().isNotEmpty) {
      Map<core.String, dynamic> map = jsonDecode(response.body);
      if (map.containsKey('data') && map['data'] != null) {
        list = jsonDecode(response.body)['data'];
      }
    }
    return list;
  }

  // service list API
  Future<ServiceListModel?> getServiceListModel() async {
    ServiceListModel? serviceListModel;
    Response? response = await serviceCall.serviceList(
        context: context, url: serviceListModelUrl);
    if (response != null &&
        response.statusCode == 200 &&
        response.body.toString().isNotEmpty) {
      serviceListModel = ServiceListModelFromJson(response.body);
    }
    return serviceListModel;
  }

  // List for serviceList
  List<niyazModel> list = [];

  List<Widget> getWidgets({required ServiceListModel serviceListModel}) {
    list.clear();
    List<Widget> widgetsList = [];
    for (var element in serviceListModel.data) {
      list.add(niyazModel(element.sName, element.id));
    }

    list.forEach((element) {
      widgetsList.add(Consumer<MyProvider>(builder: (
        context,
        data,
        Widget? child,
      ) {
        return InnerListScreen(element: element, provider: data);
      }));
    });
    return widgetsList;
  }

  LoginModel? loginModel;
  Timer? timer;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    resetSearchPlantDefaults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //background image
      body: FutureBuilder(
          future: getUserInfoData(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //logo image and top text
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //logo image
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RoPlantReport()),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 45),
                                  height: 70,
                                  width: 70,
                                  child: Image.asset(logo),
                                ),
                              ),
                              //top text
                              Text(
                                'RO Plant Report',
                                style: TextStyle(
                                    color: indigo,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: ubuntu),
                              )
                            ],
                          ),
                        ),
                        // Select RO plant name text field
                        Container(
                            margin: const EdgeInsets.only(
                                bottom: 15, left: 35, right: 35),
                            child: TypeAheadFormField(
                                getImmediateSuggestions: false,
                                debounceDuration:
                                    const Duration(microseconds: 500),
                                textFieldConfiguration: TextFieldConfiguration(
                                    textAlign: TextAlign.left,
                                    onSubmitted: (value) async {},
                                    controller: _plantNameController,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: indigo, width: 2.0),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      enabled: true,
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: red, width: 2.0),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: red, width: 2.0),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: indigo, width: 2.0),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      hintText: "Enter Plant Name",
                                      alignLabelWithHint: true,
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontFamily: ubuntu),
                                      fillColor: Colors.white,
                                    )),
                                suggestionsCallback: (String value) async {
                                  return await plantName(value);
                                },
                                itemBuilder:
                                    (BuildContext context, dynamic suggestion) {
                                  return ListTile(
                                    title: Text(suggestion['plantName']),
                                  );
                                },
                                onSuggestionSelected: (dynamic suggestion) {
                                  _plantNameController.text =
                                      suggestion['plantName'];
                                  ConstantVariables.plantName =
                                      suggestion['plantName'];
                                  ConstantVariables.plantId =
                                      suggestion['plant_id'];
                                },
                                noItemsFoundBuilder: (dynamic suggestion) {
                                  return Text('No items found');
                                })
                            // child: TextFormField(
                            //   autovalidateMode:
                            //       AutovalidateMode.onUserInteraction,
                            //   validator: (value) {
                            //     if (value != null && value.isEmpty) {
                            //       return 'Please enter RO Plant Name';
                            //     }
                            //     return null;
                            //   },
                            //   controller: _plantNameController,
                            //   onChanged: (value) async {
                            //     if (value.isNotEmpty) {
                            //       SearchPlantModel? model =
                            //           await authSearchPlant();
                            //       if (model != null &&
                            //           model.plants.data.isNotEmpty) {
                            //         ConstantVariables.plantId =
                            //             model.plants.data[0].plantId;
                            //         ConstantVariables.plantName =
                            //             model.plants.data[0].plantName;
                            //       }
                            //     }
                            //   },
                            //   autofocus: true,
                            //   decoration:
                            //       getInputDecoration(label: 'Enter Plant Name'),
                            // ),
                            ),
                        // Select plant address text field
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 35, right: 35),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value != null &&
                                  value.toString().trim().isEmpty) {
                                return 'Please enter RO Plant Address';
                              }
                              return null;
                            },
                            maxLines: 3,
                            controller: _plantAddressController,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                ConstantVariables.plantAddress = value;
                              }
                            },
                            autofocus: true,
                            decoration: getInputDecoration(
                                label: 'Enter Plant Address'),
                          ),
                        ),
                        // points to verify text
                        Container(
                          margin: const EdgeInsets.only(left: 55, bottom: 10),
                          child: Text(
                            'POINTS TO VERIFY',
                            style: TextStyle(
                                color: black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: ubuntu),
                          ),
                        ),
                        // Service lists
                        Expanded(
                            child: Container(
                          margin: const EdgeInsets.only(
                              left: 35, right: 35, bottom: 15),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(width: 2.0, color: indigo),
                          ),
                          child: FutureBuilder(
                              future: getServiceListModel(),
                              builder: (context, snapShot) {
                                if (snapShot.hasData && snapShot.data != null) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: getWidgets(
                                          serviceListModel: snapShot.data!),
                                    ),
                                  );
                                } else if (snapShot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return const Center(
                                    child: Text('Unable to Fetch Data'),
                                  );
                                }
                              }),
                        )),
                        //next button
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 40, bottom: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: indigo,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22))),
                              ),
                              onPressed: () {
                                _nextButton();
                              },
                              child: Text(
                                nextButton,
                                style: TextStyle(fontFamily: ubuntu),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Text('Something went wrong pls try agin');
            }
          }),
    );
  }
}
