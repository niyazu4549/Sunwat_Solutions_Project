import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sunwat_solutions/colors.dart';
import 'package:sunwat_solutions/common_functions.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/views/login_screen.dart';
import 'package:sunwat_solutions/views/ro_plant_report.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loginScreen();
  }

  //by using this function we will able to redirect to loginScreen
  void loginScreen() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      var data = await getSharedPreferenceData(key: 'loginData');
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => RoPlantReport()),(Route<dynamic> route) => false);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  data != null ? RoPlantReport() : LoginScreen()), (Route<dynamic> route) => false);
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        // background color
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [lightBlueAccent, white, white, lightBlueAccent])),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo image
              SizedBox(
                height: 270,
                width: 270,
                child: Image.asset(logo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
