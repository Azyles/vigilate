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

    var reference = firestore
        .collection('Cities')
        .doc(city)
        .collection("Reports")
        .where("active", isEqualTo: true);
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((point) {
        print(point.doc.data());

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
