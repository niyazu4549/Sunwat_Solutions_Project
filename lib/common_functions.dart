import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunwat_solutions/colors.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:signature/signature.dart';
import 'package:sunwat_solutions/models/login_model.dart';
import 'package:intl/intl.dart';

//by using this function we able to insert the data in the local using shared preferences
Future<bool> setSharedPreferences(
    {required String key, required String value}) async {
  bool isDataInserted = false;
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
    isDataInserted = true;
    print('data inserted successfully key=${key} value=${value}');
  } catch (ex) {
    print('ex=${ex}');
  }
  return isDataInserted;
}

//by using this function we will able to clear shared preferences
void clearSharedPreferences() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
}

//by using this function we will able to fetch shared preferences data by passing key
Future<dynamic> getSharedPreferenceData({required String key}) async {
  dynamic sharedPreferenceData;
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferenceData = sharedPreferences.getString(key);
  } catch (ex) {
    print('ex=${ex}');
  }
  return sharedPreferenceData;
}

//by using this function we will able to clear all default stored variables data
void resetSearchPlantDefaults() {
  ConstantVariables.plantId = '';
  ConstantVariables.plantName = '';
  ConstantVariables.reportId = '';
  ConstantVariables.plantAddress = '';
  ConstantVariables.serviceListDataArray.clear();
}

//by using this function we will able to clear all default stored variables data
void resetRoPlantDefaults() {
  ConstantVariables.remarks = '';
  ConstantVariables.selectedImages.clear();
  if (ConstantVariables.customerSignatureImageArray != null &&
      ConstantVariables.customerSignatureImageArray
          .toString()
          .trim()
          .isNotEmpty) {
    ConstantVariables.customerSignatureImageArray = "";
  }
  if (ConstantVariables.executiveSignatureImageArray != null &&
      ConstantVariables.executiveSignatureImageArray
          .toString()
          .trim()
          .isNotEmpty) {
    ConstantVariables.executiveSignatureImageArray = "";
  }
}

bool checkElementExistingServiceList({required String id}) {
  bool existed = false;
  for (var element in ConstantVariables.serviceListDataArray) {
    if (element.containsKey('id') && element['id'] == id) {
      ConstantVariables.serviceListDataArray.remove(element);
      existed = true;
      break;
    }
  }
  return existed;
}

bool checkObjectExistingServiceList({required String id}) {
  bool existed = false;
  for (var element in ConstantVariables.serviceListDataArray) {
    if (element.containsKey('id') && element['id'] == id) {
      existed = true;
      break;
    }
  }
  return existed;
}

//by using this function we will able to generate unit8list array from signature widget
Future<String?> generateUnit8List(
    {required SignatureController controller,
    required BuildContext context}) async {
  showAlertDialog(context, 'please wait', 'loading..');
  Uint8List? unit8ListArray;
  if (controller.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        key: Key('snackbarPNG'),
        content: Text('No content'),
      ),
    );
    return null;
  }

  unit8ListArray = await controller.toPngBytes();

  String base64String = base64Encode(unit8ListArray!);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      key: Key('success'),
      content: Text('Data Saved Successfully'),
    ),
  );
  Navigator.pop(context);
  return base64String;
}

void clearSignature({required SignatureController controller}) {
  controller.clear();
}

File createFileFromBytes(Uint8List bytes) {
  return File.fromRawPath(bytes);
}

Future<File> compressFile(File file) async {
  File compressedFile = await FlutterNativeImage.compressImage(
    file.path,
    quality: 70,
  );
  return compressedFile;
}

void displayToastMessage({required String message}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

showAlertDialog(BuildContext context, String title, String content,
    {String error = 'success'}) {
  AlertDialog alert = AlertDialog(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 16.0,
      ),
    ),
    content: Row(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(width: 20),
        Text(
          content,
          style: TextStyle(
            color: error == "success" ? Colors.green : Colors.red,
            fontSize: 14.0,
          ),
        ),
      ],
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

InputDecoration getInputDecoration({required String label}) {
  return InputDecoration(
    fillColor: white,
    isDense: true,
    filled: true,
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: indigo, width: 2.0),
      borderRadius: BorderRadius.circular(14),
    ),
    enabled: true,
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: red, width: 2.0),
      borderRadius: BorderRadius.circular(14),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: red, width: 2.0),
      borderRadius: BorderRadius.circular(14),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: indigo, width: 2.0),
      borderRadius: BorderRadius.circular(14),
    ),
    labelText: label,
  );
}

void validateForm({required GlobalKey<FormState> formKey}) {
  if (formKey.currentState != null) {
    formKey.currentState!.validate();
  }
}

Image getImage(String bytes) {
  return Image.memory(base64Decode(bytes));
}

Future<LoginModel?> getLoginInfoData() async {
  LoginModel? loginModel;
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey('loginData')){
      loginModel = LoginModel.fromJson(
          json.decode(await getSharedPreferenceData(key: 'loginData')));
      print('loginModel=${loginModel}');
    }
  } catch (ex) {
    print('ex=${ex}');
  }
  print(loginModel);
  return loginModel;
}

Map<String, dynamic> extractLogindataFromModel(
    {required LoginModel loginModel}) {
  Map<String, dynamic> loginInfoMap = {};
  try {
    if (loginModel.data.isNotEmpty &&
        loginModel.data[0].id.toString().isNotEmpty) {
      ConstantVariables.userId = loginModel.data[0].id;
      ConstantVariables.userName = loginModel.data[0].username.isNotEmpty
          ? loginModel.data[0].username
          : '';
      loginInfoMap = {
        "userId": loginModel.data[0].id,
        "userName": loginModel.data[0].username.isNotEmpty
            ? loginModel.data[0].username
            : ''
      };
    }
  } catch (ex) {}
  return loginInfoMap;
}

Widget loadNetworkImage(src) {
  return Image.network(src);
}

Future getDeviceToken() async {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? deviceToken = await firebaseMessaging.getToken();
  return (deviceToken == null) ? "" : deviceToken;
}

List<dynamic> removeDuplicatesFromList({required List<dynamic> list}) {
  // convert each item to a string by using JSON encoding
  final jsonList = list.map((item) => jsonEncode(item)).toList();

  // using toSet - toList strategy
  final uniqueJsonList = jsonList.toSet().toList();

  // convert each item back to the original form using JSON decoding
  return uniqueJsonList.map((item) => jsonDecode(item)).toList();
}

String getCurrentDatetime() {
  return DateFormat("dd-MM-yyyy").format(DateTime.now());
}
