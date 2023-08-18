import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sunwat_solutions/colors.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/controllers/service_calls.dart';
import 'package:sunwat_solutions/models/forgot_model.dart';
import 'package:sunwat_solutions/views/login_screen.dart';
import 'package:sunwat_solutions/views/signup_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _userNameController = TextEditingController();
  ServiceCall serviceCall = ServiceCall();

  // Forget password API function
  Future<ForgetPassword?> authForgetPassword() async {
    ForgetPassword? forgetPassword;
    Map<String, dynamic> map = {
      "username": _userNameController.text.toString().trim(),
    };
    Response? response = await serviceCall.forgetPassword(
        context: context, map: map, url: forgetPasswordUrl);
    if (response != null &&
        response.statusCode == 200 &&
        response.body != null &&
        response.body.toString().isNotEmpty) {
      forgetPassword = forgetPasswordFromJson(jsonDecode(response.body));
    }
    return forgetPassword;
  }

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
              white,
              lightBlueAccent,
              lightBlueAccent
            ])),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //logo image
                Container(
                  margin: const EdgeInsets.only(top: 70, bottom: 50),
                  width: 260,
                  child: Image.asset(logo),
                ),
                //lock icon
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: const Icon(Icons.lock, color: black, size: 100),
                ),
                //Enter email text
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    enterYourEmail,
                    style: TextStyle(
                        color: black, fontFamily: ubuntu, fontSize: 16),
                  ),
                ),
                // text content
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    text1,
                    style: TextStyle(
                        color: black, fontFamily: ubuntu, fontSize: 16),
                  ),
                ),
                //text content
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    newPassword,
                    style: TextStyle(
                        color: black, fontFamily: ubuntu, fontSize: 16),
                  ),
                ),
                //email text field
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      fillColor: white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: indigo, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: indigo, width: 2.0),
                      ),
                      labelText: emailOrPassword,
                      labelStyle: TextStyle(
                          fontFamily: ubuntu, fontSize: 14, color: grey),
                    ),
                  ),
                ),
                //forget button
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: indigo,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                    ),
                    onPressed: () {
                      authForgetPassword().then((value) {
                        if (value != null) {
                          ForgetPassword forgetPassword = value;
                          print('message=${forgetPassword.message}');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        }
                      });
                    },
                    child: Text(
                      forgetPassword1,
                      style: TextStyle(fontFamily: ubuntu, fontSize: 16),
                    ),
                  ),
                ),
                // signup text and signup button
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // signup text
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(
                          donTHaveAccount,
                          style: TextStyle(
                              color: black, fontSize: 16, fontFamily: ubuntu),
                        ),
                      ),
                      //signUp text button
                      InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          });
                        },
                        child: Text(
                          signUp,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: ubuntu),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
