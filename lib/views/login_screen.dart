import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sunwat_solutions/background_locations_services/background_location_service.dart';
import 'package:sunwat_solutions/background_locations_services/location_controller_cubit.dart';
import 'package:sunwat_solutions/colors.dart';
import 'package:sunwat_solutions/common_functions.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/controllers/service_calls.dart';
import 'package:sunwat_solutions/models/login_model.dart';
import 'package:sunwat_solutions/views/forget_password_screen.dart';
import 'package:sunwat_solutions/views/ro_plant_report.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
late BackgroundService backgroundService;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  ServiceCall serviceCall = ServiceCall();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  void _loginButton() {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    showAlertDialog(context, 'please wait', 'loading..');
    authLogin().then((value) async {
      if (value != null) {
        LoginModel loginModel = value;
        // print('message=${loginModel.message}');
        // print('message=${loginModel.data[0].name}');
        await setSharedPreferences(
                key: 'loginData', value: json.encode(loginModel))
            .then((value) async{

          // await backgroundService.flutterBackgroundService.startService();

          // captureGeoLocatorInfo();
          await backgroundService.initializeService();
          //Set service as foreground.(Notification will available till the service end)
          backgroundService.setServiceAsForeGround();
          Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => RoPlantReport()),(Route<dynamic> route) => false);
          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          //     LoginScreen()), (Route<dynamic> route) => false);
        });
      }
    });
  }

  validateForm() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  bool isDisagreeButtonClicked= false;
  void _showdailogue() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context,setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text("Sunwat Solutions",style: TextStyle(color: Colors.black, fontFamily: ubuntu),),
                content: RichText(
                  text: TextSpan(
                    text: isDisagreeButtonClicked? disagreeContent : agreeContent,
                    style: TextStyle(color: Colors.black, fontFamily: ubuntu,),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'privacy policy',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async{
                              final Uri url = Uri.parse(privacyPolicyUrl);
                              if (!await launchUrl(url)) {
                              throw Exception('Could not launch $privacyPolicyUrl');
                              }
                            },
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: ubuntu,
                          )),
                    ],
                  ),
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      //do something
                      Navigator.pop(context);
                      setState(() {
                        isDisagreeButtonClicked= false;
                      });
                      getGeoLocatorPermission();
                    },
                    child: Text("Agree",style: TextStyle(fontFamily: ubuntu,color: Colors.blue),),
                  ),
                  MaterialButton(
                    onPressed: () {
                      //do something
                      setState(() {
                        isDisagreeButtonClicked= true;
                      });
                    },
                    child: Text("Disagree", style: TextStyle(fontFamily: ubuntu,color: Colors.blue),),
                  ),
                ],
              );
            }
          );
        });
  }

  // login API Function
  Future<LoginModel?> authLogin() async {
    LoginModel? loginModel;
    String deviceToken = await getDeviceToken();
    Map<String, dynamic> map = {
      "username": _userNameController.text.toString().trim(),
      "password": _passwordController.text.toString().trim(),
      "fcmtoken ": deviceToken,
    };
    Response? response =
        await serviceCall.login(context: context, map: map, url: loginUrl);
    if (response != null &&
        response.statusCode == 200 &&
        response.body.toString().isNotEmpty) {
      loginModel = loginModelFromJson(response.body);
    } else {
      Navigator.pop(context);
      if (response != null &&
          response.statusCode != 200 &&
          response.body.toString().isNotEmpty) {
        Map<String, dynamic> map = json.decode(response.body);
        if (map.isNotEmpty && map.containsKey('message')) {
          displayToastMessage(message: map['message']);
        }
      }
    }
    print('status code=${response?.statusCode}');
    return loginModel;
  }

  void startLocationService() async {
    // FocusScope.of(context).unfocus();
    displayToastMessage(
        message: 'Wait for a while, Initializing the service...');

    await context
        .read<LocationControllerCubit>()
        .enableGPSWithPermission()
        .then((permission) async {
          print('permisson=${permission}');
      if (permission) {
        await context
            .read<LocationControllerCubit>()
            .locationFetchByDeviceGPS().then((value){
          print('svadcd=${value}');

        });
        ConstantVariables.deviceToken = await getDeviceToken();
//Configure the service notification channel and start the service
//         await backgroundService.initializeService();
//         //Set service as foreground.(Notification will available till the service end)
//         backgroundService.setServiceAsForeGround();
        // _loginButton();
        print('permission breaked=${permission}');
      }else{
        startLocationService();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    backgroundService = BackgroundService();
    getPermissionInfo();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    //Start the service automatically if it was activated before closing the application
    if (await backgroundService.instance.isRunning()) {
      await backgroundService.initializeService();
    }
    backgroundService.instance.on('on_location_changed').listen((event) async {
      if (event != null) {
        final position = Position(
          longitude: double.tryParse(event['longitude'].toString()) ?? 0.0,
          latitude: double.tryParse(event['latitude'].toString()) ?? 0.0,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              event['timestamp'].toInt(),
              isUtc: true),
          accuracy: double.tryParse(event['accuracy'].toString()) ?? 0.0,
          altitude: double.tryParse(event['altitude'].toString()) ?? 0.0,
          heading: double.tryParse(event['heading'].toString()) ?? 0.0,
          speed: double.tryParse(event['speed'].toString()) ?? 0.0,
          speedAccuracy:
              double.tryParse(event['speed_accuracy'].toString()) ?? 0.0,
        );

        await context
            .read<LocationControllerCubit>()
            .onLocationChanged(location: position);
      }
    });
  }

  void getGeoLocatorPermission() async{
    Location location = Location();
    bool ison = await location.serviceEnabled();
    print('ison=${ison}');
    if (!ison) { //if defvice is off
      bool isturnedon = await location.requestService();
      if (isturnedon) {
        startLocationService();
      }else{
        displayToastMessage(message: "Please turn on the GPS location");
      }
    }else{
      startLocationService();
    }

  }

  void getPermissionInfo() async{
    var permission=await Geolocator.checkPermission();

    if(permission==LocationPermission.denied || permission==LocationPermission.deniedForever){
      _showdailogue();
    }
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
              Colors.lightBlueAccent,
              Colors.lightBlueAccent
            ])),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //logo image
                  Container(
                    margin: const EdgeInsets.only(top: 70, bottom: 80),
                    width: 260,
                    child: Image.asset(logo),
                  ),
                  //user name text field
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please Enter user Name';
                        }
                        return null;
                      },
                      controller: _userNameController,
                      decoration: getInputDecoration(label: 'Enter Email'),
                    ),
                  ),
                  //password text field
                  Container(
                    margin: const EdgeInsets.only(bottom: 35),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      decoration: getInputDecoration(label: 'Enter Password'),
                    ),
                  ),
                  //login button inside this widget
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: indigo,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(22))),
                      ),
                      onPressed: () async{
                        // getGeoLocatorPermission();
                        var permission=await Geolocator.checkPermission();

                        print('permission${permission}');
                        if(permission==LocationPermission.denied || permission==LocationPermission.deniedForever){
                          _showdailogue();
                        }else{
                          _loginButton();
                        }
                      },
                      child: Text(
                        login,
                        style: TextStyle(fontFamily: ubuntu),
                      ),
                    ),
                  ),
                  //forget password button
                  InkWell(
                    onTap: () {
                      // setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen()));
                      // });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        forgetPassword,
                        style: TextStyle(
                            color: black, fontSize: 17, fontFamily: ubuntu),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
