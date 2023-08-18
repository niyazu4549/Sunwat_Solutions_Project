import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sunwat_solutions/background_locations_services/location_service_repository.dart';

part 'location_controller_state.dart';

class LocationControllerCubit extends Cubit<LocationControllerState> {
  final LocationServiceRepository locationServiceRepository;

  LocationControllerCubit({
    required this.locationServiceRepository,
  }) : super(StopLocationFetch());

  Future<void> stopLocationFetch() async {
    emit(LoadingLocation());
    emit(StopLocationFetch());
  }

  Future<void> onLocationChanged({
    required Position location,
  }) async {
    try {
      emit(LoadingLocation());
      emit(LocationFetched(location: location));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      emit(LocationError(error: e.toString()));
    }
  }

  Future<Position?> locationFetchByDeviceGPS() async {
    try {
      emit(LoadingLocation());
      final selectedLocation =
          await locationServiceRepository.fetchLocationByDeviceGPS();
      emit(LocationFetched(location: selectedLocation));
      return selectedLocation;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      emit(LocationError(error: e.toString()));
      return null;
    }
  }

  Future<bool> enableGPSWithPermission() async {
    try {
      await locationServiceRepository.fetchLocationByDeviceGPS();
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }
}
