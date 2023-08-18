import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sunwat_solutions/common_functions.dart';
import 'package:sunwat_solutions/controllers/http_calls.dart';

class ServiceCall {
  Future<Response?> login(
      {required BuildContext context,
      required Map<String, dynamic> map,
      required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print('ex=${ex}');
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> changePassword(
      {required BuildContext context,
      required Map<String, dynamic> map,
      required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> forgetPassword(
      {required BuildContext context,
      required Map<String, dynamic> map,
      required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> searchPlant(
      {required BuildContext context,
      required Map<String, dynamic> map,
      required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> serviceList(
      {required BuildContext context, required String url}) async {
    Response? response;
    try {
      response = await getMethodWithoutBody(context: context, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> signUp(
      {required BuildContext context,
      required Map<String, dynamic> map,
      required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> nextButton(
      {required BuildContext context,
      required Map<String, dynamic> map,
      required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> submitButton(
      {required BuildContext context,
      required Map<String, dynamic> map,
      required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> location(
      {required BuildContext context,
      required Map<String, dynamic> map,
      required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> reports(
      {required BuildContext context, required String url}) async {
    Response? response;
    try {
      response = await getMethodWithoutBody(context: context, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> viewButton(
      {required BuildContext context,
      required Map<String, dynamic> map,
      required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> plantName(
      {required BuildContext context, required String url}) async {
    Response? response;
    try {
      response = await getMethodWithoutBody(context: context, url: url);
    } catch (ex) {
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }

  Future<Response?> logOut(
      {required BuildContext context,
        required Map<String, dynamic> map,
        required String url}) async {
    Response? response;
    try {
      response = await postMethodWithBody(context: context, map: map, url: url);
    } catch (ex) {
      print('ex=${ex}');
      print(ex);
      displayToastMessage(message: 'Unable to Fetch the Data from Server');
    }
    return response;
  }
}
