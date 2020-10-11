import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class Backend {
  var city = '';

  getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    print('location: ${position.latitude}, ${position.longitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");

    print("City : ${first.locality}");

    city = first.locality;

    var location = first.addressLine;

    var street = location.substring(0, location.indexOf(','));

    return ([position.latitude, position.longitude, first.locality, street]);
  }

  getLiveAlerts(city) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    print("GEtting live alerts");

    var location = await getCurrentLocation();

    var latitude = location[0];
    var longitude = location[1];

    // ~1 mile of lat and lon in degrees
    var lat = 0.0144927536231884;
    var lon = 0.0181818181818182;

    var lowerLat = latitude - (lat * 3);
    var lowerLon = longitude - (lon * 3);

    var greaterLat = latitude + (lat * 3);
    var greaterLon = longitude + (lon * 3);

    var lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    var greaterGeopoint = GeoPoint(greaterLat, greaterLon);

    var reference =
        firestore.collection('Cities').doc(city).collection("Alerts");

    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((point) {
        print("NEW POLICE ALERT" + point.doc.data().toString());

        var data = point.doc.data();

        var long = data['longitude'];

        var lat = data['latitude'];

        var reportTime = data['time'];

        var id = point.doc.id;

        var description = data['description'];
      });
    });
  }
}
