import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sunwat_solutions/background_locations_services/location_controller_cubit.dart';
import 'package:sunwat_solutions/background_locations_services/location_service_repository.dart';
import 'package:sunwat_solutions/views/provider_class.dart';
import 'package:sunwat_solutions/views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MultiProvider(providers: [
    BlocProvider(
      create: (context) => LocationControllerCubit(
        locationServiceRepository: LocationServiceRepository(),
      ),
    ),
    ChangeNotifierProvider(create: (_) => MyProvider()),
  ], child: const SunwatApp()));
}

class SunwatApp extends StatelessWidget {
  const SunwatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
