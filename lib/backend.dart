import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Backend {
  var city = '';

  getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('location: ${position.latitude}, ${position.longitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");

    print("City : ${first.locality}");

    city = first.locality;

    return ([position.latitude, position.longitude, first.locality]);
  }

  getLivePoints(city) {
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

        
      });
    });
  }
}
