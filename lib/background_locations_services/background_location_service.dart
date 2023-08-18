import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:sunwat_solutions/common_functions.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/controllers/service_calls.dart';
import 'package:sunwat_solutions/models/login_model.dart';

const String notificationChannelId = "foreground_service";
const int foregroundServiceNotificationId = 888;
const String initialNotificationTitle = "TRACK YOUR LOCATION";
const String initialNotificationContent = "Initializing";
const int timeInterval = 10; //in seconds
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) async {
      await service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) async {
      await service.setAsBackgroundService();
    });
  }

  service.on("stop_service").listen((event) async {
    await service.stopSelf();
  });

  // bring to foreground

  Timer.periodic(const Duration(seconds: timeInterval), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        Geolocator.getPositionStream().listen((Position position) async {
          final permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.always) {
            service.invoke('on_location_changed', position.toJson());
            startLocationCaptureData(position: position);
            print('service running...');
          }
        });
      }
    }
  });
}
void startLocationCaptureData({required Position position}) async{
  Map<String, dynamic> userInfoMap = await getUserInfoData();
  String? userId;
  if (userInfoMap.isNotEmpty &&
      userInfoMap.containsKey('userId') &&
      userInfoMap["userId"] != null) {
    userId = userInfoMap["userId"].toString().trim();
    Map<String, dynamic> locationRequestObject = {
      "user_id": userId,
      "lattitude": position.latitude,
      "longitude": position.longitude,
    };
    await authLocation(locationRequestObject: locationRequestObject);
  }
}
Future<Map<String, dynamic>> getUserInfoData() async {
  Map<String, dynamic> getUserInfoMap = {};
  try {
    LoginModel? loginModel = await getLoginInfoData();
    if (loginModel != null) {
      getUserInfoMap = extractLogindataFromModel(loginModel: loginModel);
    }
  } catch (ex) {
    print('userInfoERROR=${ex}');
  }
  return getUserInfoMap;
}

Future<Map<String, dynamic>?> authLocation(
    {required Map<String, dynamic> locationRequestObject}) async {
  Map<String, dynamic> responseExtractedMap = {};
  print('locationRequestObject=${locationRequestObject}');
  ServiceCall serviceCall = ServiceCall();
  Response? response = await http.post(Uri.parse(locationUrl),
      body: jsonEncode(locationRequestObject), headers: getHeaders);
  if (response != null &&
      response.statusCode == 200 &&
      response.body.toString().isNotEmpty) {
    if (json.decode(response.body) is Map<String, dynamic>) {
      responseExtractedMap = json.decode(response.body);
    }
    print('Api test=${responseExtractedMap}');
  }
  return responseExtractedMap;
}
@pragma('vm:entry-point')
class BackgroundService {
  //Get instance for flutter background service plugin
  final FlutterBackgroundService flutterBackgroundService =
  FlutterBackgroundService();

  FlutterBackgroundService get instance => flutterBackgroundService;
  Future<void> initializeService() async {
    await flutterBackgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: true,
        isForegroundMode: true,
        autoStartOnBoot: true
      ),
      //Currently IOS setup is not completed.
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,
      ),
    );
    await flutterBackgroundService.startService();
  }
  @pragma('vm:entry-point')
  void setServiceAsForeGround() async {
    flutterBackgroundService.invoke("setAsForeground");
  }
  @pragma('vm:entry-point')
  void stopService() {
    flutterBackgroundService.invoke("stop_service");
  }
}
