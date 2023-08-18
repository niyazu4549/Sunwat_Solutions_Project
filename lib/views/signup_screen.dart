import 'package:flutter/material.dart';
import 'package:sunwat_solutions/colors.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/views/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  String name = '';

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        // background color
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [white, white, lightBlueAccent])),
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
                  margin: const EdgeInsets.only(top: 70, bottom: 20),
                  width: 260,
                  child: Image.asset(logo),
                ),
                //text content
                Container(
                    child: Text(
                  content1,
                  style:
                      TextStyle(color: black, fontSize: 18, fontFamily: ubuntu),
                )),
                //text content
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      content2,
                      style: TextStyle(
                          color: black, fontSize: 18, fontFamily: ubuntu),
                    )),
                // Email text field
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: indigo, width: 2.0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: indigo, width: 2.0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      hintText: email,
                      hintStyle: TextStyle(
                          color: grey, fontFamily: ubuntu, fontSize: 14),
                      labelStyle: TextStyle(
                          fontFamily: ubuntu, fontSize: 14, color: grey),
                    ),
                    // validator: (value){
                    //   if(value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)){
                    //     return "Enter correct Email or number";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                  ),
                ),
                // FullName text field
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: indigo, width: 2.0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: indigo, width: 2.0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      hintText: fullName,
                      hintStyle: TextStyle(
                          color: grey, fontFamily: ubuntu, fontSize: 14),
                    ),
                    // validator: (value){
                    //   if(value!.isEmpty || !RegExp(r'^[+]*[(]{0,1}[0-9]{1-4}[)]{0,1}[-\s\./0-9]+$').hasMatch(value!)){
                    //     return "Enter correct Name";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                  ),
                ),
                // Username text field
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: indigo, width: 2.0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: indigo, width: 2.0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      hintText: userName,
                      hintStyle: TextStyle(
                          color: grey, fontFamily: ubuntu, fontSize: 14),
                    ),
                    // validator: (value){
                    //   if(value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value!)){
                    //     return "Enter valid Username";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                  ),
                ),
                // Password text field
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: indigo, width: 2.0),
                      ),
                      hintText: password,
                      hintStyle: TextStyle(
                          color: grey, fontFamily: ubuntu, fontSize: 14),
                    ),
                  ),
                ),
                // SignUp button
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: indigo,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                      elevation: 3,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text(
                      signUp,
                      style: TextStyle(fontFamily: ubuntu, fontSize: 16),
                    ),
                  ),
                ),
                // text content and login text button
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // text content
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Text(
                          account,
                          style: TextStyle(
                              color: black, fontSize: 17, fontFamily: ubuntu),
                        ),
                      ),
                      // login text button
                      InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          });
                        },
                        child: Container(
                          child: Text(
                            login,
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                fontFamily: ubuntu),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //bottom text
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    content4,
                    style: TextStyle(
                        color: black, fontFamily: ubuntu, fontSize: 14),
                  ),
                ),
                //learn more text button
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: Text(
                    learnMore,
                    style: TextStyle(
                        color: black,
                        fontFamily: ubuntu,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
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
