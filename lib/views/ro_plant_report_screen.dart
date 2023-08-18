import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sunwat_solutions/colors.dart';
import 'package:sunwat_solutions/common_functions.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/controllers/service_calls.dart';
import 'package:sunwat_solutions/views/ro_plant_report.dart';
import 'dart:async';
import 'dart:io';
import 'package:signature/signature.dart';
import 'package:flutter/scheduler.dart';
import 'package:sunwat_solutions/views/search_plant_screen.dart';

class RoPlantReportScreen extends StatefulWidget {
  const RoPlantReportScreen({Key? key}) : super(key: key);

  @override
  State<RoPlantReportScreen> createState() => _RoPlantReportScreenState();
}

class _RoPlantReportScreenState extends State<RoPlantReportScreen> {
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _plantPhotosController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  final TextEditingController _reportOneController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _executiveNameController =
      TextEditingController();

  XFile? imageFile;
  XFile? videoFile;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  File? image;
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  FocusNode remarksFocusNode = FocusNode();
  FocusNode imagesFocusNode = FocusNode();
  FocusNode customerFocusNode = FocusNode();
  FocusNode executiveFocusNode = FocusNode();

  void _submitButton() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    if (ConstantVariables.customerSignatureImageArray == null ||
        ConstantVariables.customerSignatureImageArray!.isEmpty) {
      displayToastMessage(message: 'Please enter customer signature');
      return;
    }
    if (ConstantVariables.executiveSignatureImageArray == null ||
        ConstantVariables.executiveSignatureImageArray!.isEmpty) {
      displayToastMessage(message: 'Please enter executive signature');
      return;
    }
    showAlertDialog(context, 'please wait', 'loading..');
    Map<String, dynamic>? mapBody = await authSubmitButton();
    if (mapBody != null &&
        mapBody.isNotEmpty &&
        mapBody.containsKey('message') &&
        mapBody['message'] != null &&
        mapBody.containsKey('report_id') &&
        mapBody['report_id'] != null) {
      print('return response printed=${mapBody}');
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoPlantReport()),
      );
    }
  }

  ServiceCall serviceCall = ServiceCall();
  final SignatureController customerSignatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );
  final SignatureController executiveSignatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.red,
    exportBackgroundColor: Colors.blue,
  );

  @override
  void initState() {
    super.initState();
    resetRoPlantDefaults();
    customerSignatureController.addListener(() => print('Value changed'));
    executiveSignatureController.addListener(() => print('Value changed'));
  }

  @override
  void dispose() {
    customerSignatureController.dispose();
    executiveSignatureController.dispose();
    super.dispose();
  }

  // Camera Functionality
  void pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxWidth: 300, maxHeight: 300);
      if (image == null) return;
      this.image = File(image.path);
      print('image test');
      if (this.image != null) {
        File file = await compressFile(this.image!);
        List<int> bytes = await file.readAsBytesSync();
        ConstantVariables.selectedImages.add(base64Encode(bytes));
        ConstantVariables.selectedImages =
            ConstantVariables.selectedImages.reversed.toList();
        _plantPhotosController.text = this.image!.path.toString();
        setState(() {});
      }
    } on PlatformException catch (e) {
      print('Failed to pic image: $e');
    }
  }

  Future<Map<String, dynamic>?> authSubmitButton() async {
    Map<String, dynamic> responseExtractedMap = {};

    Map<String, dynamic> reqObject = {
      "report_id": ConstantVariables.reportId,
      "remarks": ConstantVariables.remarks,
      "cust_name": ConstantVariables.customerName,
      "cust_sign": ConstantVariables.customerSignatureImageArray,
      "exec_name": ConstantVariables.executiveName,
      "exe_sign": ConstantVariables.executiveSignatureImageArray,
      "plantimg":
          ConstantVariables.selectedImages.map((e) => e.toString()).toList(),
    };
    print('reqObject=${reqObject}');
    Response? response = await serviceCall.submitButton(
        context: context, map: reqObject, url: uploadUrl);
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

  Uint8List? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          // background color
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
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //logo image and top text
                  Container(
                    margin:
                        const EdgeInsets.only(top: 10, left: 20, bottom: 10),
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
                                    builder: (context) =>
                                        const SearchPlantScreen()));
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
                              fontFamily: ubuntu,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  // remarks text field
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 15, left: 35, right: 20),
                    child: TextFormField(
                      focusNode: remarksFocusNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != null && value!.isEmpty) {
                          return 'Please enter Remarks';
                        }
                        return null;
                      },
                      controller: _remarksController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          ConstantVariables.remarks = value;
                        }
                      },
                      decoration: getInputDecoration(label: 'Enter Remarks'),
                    ),
                  ),
                  // plant photos text field
                  ConstantVariables.selectedImages.isNotEmpty
                      ? Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 35, right: 20),
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                for (int i = 0;
                                    i < ConstantVariables.selectedImages.length;
                                    i++)
                                  Card(
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 5),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18))),
                                      child: Image.memory(base64Decode(
                                          ConstantVariables.selectedImages[i])))
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 35, right: 20),
                    child: TextFormField(
                      focusNode: imagesFocusNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {},
                      onTap: () {
                        pickImage(ImageSource.camera);
                      },
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please select the image';
                        }
                        return null;
                      },
                      controller: _plantPhotosController,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        fillColor: white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: indigo, width: 2.0),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: indigo, width: 2.0),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        hintText: plantPhotos,
                        hintStyle: TextStyle(
                            color: grey, fontFamily: ubuntu, fontSize: 14),
                        suffixIcon: Container(
                          margin: const EdgeInsets.only(right: 5),
                          height: 20,
                          width: 20,
                          decoration: const BoxDecoration(
                            color: indigo,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: GestureDetector(
                                  onTap: () {
                                    pickImage(ImageSource.camera);
                                  },
                                  child: const Icon(Icons.camera_alt,
                                      color: white, size: 23))),
                        ),
                      ),
                    ),
                  ),
                  //text for text field
                  Container(
                    margin: const EdgeInsets.only(left: 40, bottom: 3),
                    child: Text(
                      textForTextField,
                      style: TextStyle(
                          color: black, fontSize: 17, fontFamily: ubuntu),
                    ),
                  ),
                  //text for text field
                  Container(
                    margin: const EdgeInsets.only(left: 40, bottom: 2),
                    child: Text(
                      textForTextField1,
                      style: TextStyle(
                          color: black, fontSize: 17, fontFamily: ubuntu),
                    ),
                  ),
                  //text for text field
                  Container(
                    margin: const EdgeInsets.only(left: 40, bottom: 10),
                    child: Text(
                      textForTextField2,
                      style: TextStyle(
                          color: black, fontSize: 17, fontFamily: ubuntu),
                    ),
                  ),
                  // report text field
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 15, left: 35, right: 20),
                    child: TextFormField(
                      focusNode: customerFocusNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != null && value!.isEmpty) {
                          return 'Please enter Customer Name';
                        }
                        return null;
                      },
                      controller: _customerNameController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          ConstantVariables.customerName = value;
                        }
                      },
                      decoration:
                          getInputDecoration(label: 'Enter Customer Name'),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 15, left: 35, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 3.0, color: Colors.indigo),
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Signature(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        key: const Key('signature'),
                        controller: customerSignatureController,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  // signature buttons
                  Container(
                    margin:
                        const EdgeInsets.only(left: 35, right: 20, bottom: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // customer signature button
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: indigo,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22))),
                              ),
                              onPressed: () async {
                                remarksFocusNode.unfocus();
                                imagesFocusNode.unfocus();
                                ConstantVariables.customerSignatureImageArray =
                                    await generateUnit8List(
                                        controller: customerSignatureController,
                                        context: context);
                              },
                              child: Text(
                                customerSignatureButton,
                                style:
                                    TextStyle(fontFamily: ubuntu, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        //for spacing
                        const SizedBox(
                          width: 10,
                        ),
                        // clear signature button
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: indigo,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22))),
                              ),
                              onPressed: () {
                                if (ConstantVariables
                                            .customerSignatureImageArray !=
                                        null &&
                                    ConstantVariables
                                        .customerSignatureImageArray
                                        .toString()
                                        .trim()
                                        .isNotEmpty) {
                                  ConstantVariables
                                      .customerSignatureImageArray = "";
                                }
                                clearSignature(
                                    controller: customerSignatureController);
                              },
                              child: Text(
                                clearSignatureButton,
                                style:
                                    TextStyle(fontFamily: ubuntu, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //text for text field
                  Container(
                    margin: const EdgeInsets.only(left: 45, bottom: 3),
                    child: Text(
                      textForTextField3,
                      style: TextStyle(
                          color: black, fontSize: 17, fontFamily: ubuntu),
                    ),
                  ),
                  //text for text field
                  Container(
                    margin: const EdgeInsets.only(left: 45, bottom: 15),
                    child: Text(
                      textForTextField4,
                      style: TextStyle(
                          color: black, fontSize: 17, fontFamily: ubuntu),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 15, left: 35, right: 20),
                    child: TextFormField(
                      focusNode: executiveFocusNode,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != null && value!.isEmpty) {
                          return 'Please enter Executive Name';
                        }
                        return null;
                      },
                      controller: _executiveNameController,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          ConstantVariables.executiveName = value;
                        }
                      },
                      decoration:
                          getInputDecoration(label: 'Enter Executive Name'),
                    ),
                  ),
                  // report text field
                  Container(
                    margin:
                        const EdgeInsets.only(bottom: 15, left: 35, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                      border: Border.all(width: 3.0, color: Colors.indigo),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Signature(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        key: const Key('signature'),
                        controller: executiveSignatureController,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  // signature buttons
                  Container(
                    margin:
                        const EdgeInsets.only(left: 35, right: 20, bottom: 40),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // executive signature button
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: indigo,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22))),
                              ),
                              onPressed: () async {
                                remarksFocusNode.unfocus();
                                imagesFocusNode.unfocus();
                                ConstantVariables.executiveSignatureImageArray =
                                    await generateUnit8List(
                                        controller:
                                            executiveSignatureController,
                                        context: context);
                              },
                              child: Text(
                                executiveSignatureButton,
                                style:
                                    TextStyle(fontFamily: ubuntu, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        //for spacing
                        const SizedBox(
                          width: 10,
                        ),
                        // clear signature button
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: indigo,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22))),
                              ),
                              onPressed: () {
                                if (ConstantVariables
                                            .executiveSignatureImageArray !=
                                        null &&
                                    ConstantVariables
                                        .executiveSignatureImageArray
                                        .toString()
                                        .trim()
                                        .isNotEmpty) {
                                  ConstantVariables
                                      .executiveSignatureImageArray = "";
                                }
                                clearSignature(
                                    controller: executiveSignatureController);
                              },
                              child: Text(
                                clearSignatureButton,
                                style:
                                    TextStyle(fontFamily: ubuntu, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //submit and cancel buttons
                  Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // submit button
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: orangeAccent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                              ),
                              onPressed: () async {
                                _submitButton();
                              },
                              child: Text(
                                submitButton,
                                style:
                                    TextStyle(fontFamily: ubuntu, fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                        //for spacing
                        const SizedBox(
                          width: 10,
                        ),
                        // cancel button
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: orangeAccent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                              ),
                              onPressed: () {},
                              child: Text(
                                cancelButton,
                                style:
                                    TextStyle(fontFamily: ubuntu, fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
