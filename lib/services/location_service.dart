import 'package:find_my_tennis/services/permissions_service.dart';
import 'package:find_my_tennis/utlities/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  PermissionsService _permissionsService;
  LatLng lastReturnedLocation;

  set permissionsService(PermissionsService value) {
    if (_permissionsService != value) _permissionsService = value;
  }

  Future<LatLng> getUserLocation() async {
    if (!await _permissionsService.hasLocationPermission())
      PermissionsService().requestLocationPermission();

    if (await _permissionsService.hasLocationPermission()) {
      Location _location = Location();
      LocationData _userLocation = await _location.getLocation();
      lastReturnedLocation =
          LatLng(_userLocation.latitude, _userLocation.longitude);
      return lastReturnedLocation;
    } else
      //return wimbledon as the location
      return Constants.wimbledon;
  }
}
