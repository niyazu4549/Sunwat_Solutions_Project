import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sunwat_solutions/constants.dart';

Future<Response?> postMethodWithBody(
    {required BuildContext context,
    required Map<String, dynamic> map,
    required String url}) async {
  Response? response;
  try {
    response = await http.post(Uri.parse(url),
        body: jsonEncode(map), headers: getHeaders);
  } catch (ex) {
    print('exo=${ex}');
    throw ex;
  }
  return response;
}

Future<Response?> getMethodWithoutBody(
    {required BuildContext context, required String url}) async {
  Response? response;
  try {
    response = await http.get(Uri.parse(url), headers: getHeaders);
  } catch (ex) {
    rethrow;
  }
  return response;
}
