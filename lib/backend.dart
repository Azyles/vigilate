import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class Backend {
  
  getCurrentLocation() async {
    LocationData currentLocation;

    LocationData myLocation;

      String error;
      Location location = new Location();
      try {
        myLocation = await location.getLocation();
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          error = 'please grant permission';
          print(error);
        }
        if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
          error = 'permission denied- please enable it from app settings';
          print(error);
        }
        myLocation = null;
      }
      currentLocation = myLocation;


      final coordinates = new Coordinates(
          myLocation.latitude, myLocation.longitude);

      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);

      var first = addresses.first;
      print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');



  }
}
